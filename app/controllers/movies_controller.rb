class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #logger.info params.inspect

    @filters = {}

    @movies = if params[:ratings]
      params[:ratings].each_key { |k| @filters[k] = true }
      Movie.where(:rating => params[:ratings].keys)
    else
      Movie.all
    end
      
    @movies = case params['sort-by']
      when 'title'
        @hilite_title = true
        @movies.order('title')
      when 'release_date'
        @hilite_release_date = true
        @movies.order('release_date')
      else
        @movies
    end

    @all_ratings = Movie.select(:rating).map { |x| x.rating }.uniq
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
