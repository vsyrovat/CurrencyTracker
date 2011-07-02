class CountriesController < ApplicationController
	before_filter :set_active_item

  # GET /countries
  # GET /countries.xml
  def index
    @countries = Country.all

    @chart_data = {}
    if @user
	    visits = @user.visits.sort_by{|visit| visit[:visit_date]}
	    min_date = visits.first[:visit_date]
	    max_date = visits.last[:visit_date]
			visits.each do |visit|
				if visit.visit_date.is_a? Date
					key = visit.visit_date.year.to_s + '-' + sprintf("%02d", visit.visit_date.month.to_s)
					@chart_data[key] = @chart_data[key].nil? ? 1 : @chart_data[key] + 1
				end
			end
	    for i in (min_date.year*100 + min_date.month)..(max_date.year*100 + max_date.month)
		    key = (i/100).to_s + '-' + sprintf("%02d", (i%100).to_s)
		    @chart_data[key] = 0 if @chart_data[key].nil?
	    end
	    @chart_data = @chart_data.sort
			if @chart_data.size > 1
				q = 0
				x = {}
				@chart_data.each{|k, v|
					q = v + q
					x[k]=q
				}
				@chart_data = x
			end
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @countries }
    end
  end

  # GET /countries/1
  # GET /countries/1.xml
  def show
    @country = Country.find(params[:id])
    @visit = (@country.visits & @user.visits).first

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @country }
    end
  end

  # GET /countries/1/edit
  def edit
    @country = Country.find(params[:id])
	  @visit = (@country.visits & @user.visits).first
  end

  # POST /countries
  # POST /countries.xml
  def create
    @country = Country.new(params[:country])

    respond_to do |format|
      if @country.save
        format.html { redirect_to(@country, :notice => 'Country was successfully created.') }
        format.xml  { render :xml => @country, :status => :created, :location => @country }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @country.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /countries/1
  # PUT /countries/1.xml
  def update
    @country = Country.find(params[:id])

    respond_to do |format|
      if
        case
	         when params[:visited]
		         unless @user.countries.include?(@country)
			         @user.countries << @country
		         end
		         visit = (@user.visits & @country.visits).first
		         puts params[:visit_date].inspect
		         visit.visit_date = params[:visit_date].strip.empty? ? Date.today : params[:visit_date]
		         visit.save!
	        else
		        @user.countries.delete(@country) if @user.countries.include?(@country)
        end
        format.html { redirect_to(@country, :notice => 'Country was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { redirect_to({:action => :edit, :code => @country.code}, :notice => 'Country was not changed')}
        format.xml  { render :xml => @country.errors, :status => :unprocessable_entity }
      end
    end
  end

	def update_list
		if request.post?
			selected_countries = Country.find(:all, :conditions => {:code => params[:visited].to_a})
			Country.all.each do |country|
				if @user.countries.include?(country)
					@user.countries.delete(country) if !selected_countries.include?(country)
				else
					if selected_countries.include?(country)
						@user.countries << country
						visit = (@user.visits & country.visits).first
						visit.visit_date = Date.today
						visit.save!
					end
				end
			end
			redirect_to({:action => :index}, :notice => 'Country list successfully updated') and return

		end
		redirect_to :action => :index
	end

	private

	def set_active_item
		@active_item = :countries
	end

end