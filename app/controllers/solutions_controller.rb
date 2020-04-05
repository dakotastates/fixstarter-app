class SolutionsController < ApplicationController

  get '/solutions' do
    authenticate_user
    @solutions = Solution.all
    erb :'/solutions/index'
  end

  get '/solutions/new' do
    authenticate_user
    @problems = Problem.all
    erb :'/solutions/new'
  end
#might not need anymore
  post '/solutions/new' do
    authenticate_user
    # params[:solution][:problem] = params[:solution][:selected_problem] if !params[:solution][:selected_problem].empty?
    # if !params[:solution][:title].empty? && !params[:solution][:problem].empty?
    #   problem = Problem.find_or_create_by(title: params[:solution][:problem])
      # @solution = Solution.create(title: params[:solution][:title], problem: problem, user_id: current_user.id)
    @solution = Solution.create(name: params[:solution][:title], description: params[:solution][:description], problem_id: params[:solution][:problem], user_id: current_user.id)
    # @problem = find_problem(problem_title: params[:solution][:problem])
      #The Proposal was successfully added
    redirect "/solutions/#{@solution.id}"
    # else
    #   #Both fields must be filled in. Please complete the form.
    #   redirect '/solutions/new'
    # end
  end

  get '/solutions/:id' do
    authenticate_user
    @solution = Solution.find_by_id(params[:id])
    if @solution
      @problem = Problem.find_by_id(@solution.problem_id)
      erb :'/solutions/show'
    else
      #This proposal does not exist
      redirect '/solutions'
    end
  end

  get '/solutions/:id/edit' do
    authenticate_user
    @solution = Solution.find_by_id(params[:id])
    if @solution && @solution.user == current_user
      erb :'/solutions/edit'
    elsif @solution && !@solution.user == current_user
      #You cannot change another user's proposal.
      redirect "/solutions/#{@solution.id}"
    else
      #This Proposal doesn't exist.
      redirect  "/solutions"
    end
  end

  patch '/solutions/:id/edit' do
    authenticate_user
    @solution = Solution.find_by_id(params[:id])
    if !params[:solution][:name].empty?
      @solution.update(name: params[:solution][:name],
                       description: params[:solution][:description])
      #The proposal is successfully updated.
      redirect  "/solutions/#{@solution.id}"
    else
      redirect "/solutions/#{@solution.id}/edit"
    end
  end

  get '/solutions/:id/delete' do
    authenticate_user
    @solution = Solution.find_by_id(params[:id])
    @problem = @solution.problem
    if @solution.user == current_user
      @solution.destroy
      #The proposal was successfully deleted.
      redirect "/problems/#{@problem.id}"
    else
      #You cannot delete another user's proposals.
      redirect "/solutions/#{@solution.id}"
    end
  end

  private
  def find_problem(problem_id)
    puts problem_title
      Problem.all do |p|
        if p.id==problem_id
          @problem = p
        end
      end
    @problem
  end
end
