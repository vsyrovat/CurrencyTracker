class CountriesController < ApplicationController
	before_filter :set_active_item

  # GET /countries
  # GET /countries.xml
  def index
    @countries = Country.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @countries }
    end
  end

  # GET /countries/1
  # GET /countries/1.xml
  def show
    @country = Country.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @country }
    end
  end

  # GET /countries/1/edit
  def edit
    @country = Country.find(params[:id])
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
      if case
	        when params[:visited]
		        @user.countries << @country unless @user.countries.include?(@country)
	        else
		        @user.countries.delete(@country) if @user.countries.include?(@country)
        end
        format.html { redirect_to(@country, :notice => 'Country was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
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
					@user.countries << country if selected_countries.include?(country)
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