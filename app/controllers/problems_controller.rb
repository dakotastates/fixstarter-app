
class ProblemsController < ApplicationController

  get '/problems' do
    authenticate_user
    @problems = Problem.all
    erb :'/problems/index'
  end

  get '/problems/new' do
    authenticate_user
    @problems = Problem.all
    @problem_message = "Report your problem here"
    erb :'/problems/new'
  end

  post '/problems/new' do
    authenticate_user
    if params[:problem][:title].empty? && params[:problem][:description].empty?
      @problem_message = "Please Enter a Problem Title and Description. "
      erb :'/problems/new'
    else
      @problem = Problem.create(title: params[:problem][:title],
                                user_id: current_user.id,
                                description: params[:problem][:description],
                                location: params[:problem][:location],
                                tags: params[:problem][:tags],
                                category: params[:problem][:category],
                                severity: params[:problem][:severity],
                                status: false
                              )
      #The Problem was successfully Reported.
      redirect "/problems/#{@problem.id}"
    end
  end

  get '/problems/:id' do
    authenticate_user
      @problem = Problem.find_by_id(params[:id])
      @user = User.find_by_id(@problem.user_id)
      erb :'/problems/show'
  end

  get '/problems/:id/add_solution' do
      authenticate_user
      @problem = Problem.find_by_id(params[:id])
      erb :'/solutions/new'
    end

    post '/problems/:id/add_solution' do
        @problem = Problem.find_by_id(params[:id])
        if !params[:solution_name].empty? && !params[:solution_name].empty?
          Solution.create(name: params[:solution_name], problem: @problem, user: current_user)

          #@problem_message = "The Proposal was Successfully Added "
          redirect "/problems/#{@problem.id}"
        else
          @problem_message = "Enter the Proposal's Title and Description."
          redirect "/problems/#{@problem.id}/add_solution"
        end
      end

  get '/problems/:id/edit' do
    authenticate_user
    @problem = Problem.find_by_id(params[:id])
    if @problem && @problem.user_id == current_user.id
      erb :'/problems/edit'
    elsif @problem && !@problem.user == current_user
      @problem_message = "You cannot change another person's proposal "
      redirect to "/problems/#{@problem.id}"
    else
      @problem_message = "This Proposal Doesn't Exist "
      redirect to "/problems"
    end
  end

  patch '/problems/:id/edit' do
    authenticate_user
    @problem = Problem.find_by_id(params[:id])
    if @problem.update(params[:problem])
      redirect "/problems/#{@problem.id}"
    else
      redirect "/problems/#{@problem.id}/edit"
    end
  end

  get '/problems/:id/delete' do
      authenticate_user
      @problem = Problem.find_by_id(params[:id])
      #@solution = @problem.solution
      if @problem.user_id == current_user.id
        # Delete all associated solutions to a problem
        Solution.all.each do |sol|
          if sol.problem_id == @problem.id
            sol.destroy
          end
        end
        @problem.destroy
        #@problem_message = "The Report was Successfully Deleted "
        redirect "/problems"
      else
        @problem_message = "You can not delete another user's Reports "
        redirect to "/problems/#{@problem.id}"
      end
    end

    private
    def find_problem
        @problem = Problem.find_by_id(params[:id])
    end
end
