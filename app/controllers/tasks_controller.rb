class TasksController < ApplicationController
  layout "admin"
  before_action :set_task, only: [:show, :update, :destroy, :update_is_done]
  def index
    @breadcrumbs = [
      ["Dashboard", root_path],
      ["Todo List", nil]
    ]
    @tasks = Task.where(user_id: Current.user.id).order(created_at: :desc)
  end

  def new
    @breadcrumbs = [
      ["Dashboard", root_path],
      ["Todo List", tasks_path],
      ["New Task", nil]
    ]

    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = Current.user.id
    if @task.save
      redirect_to tasks_path, notice: "Task was successfully created."
    else
      render :new
    end
  end

  def show
    @breadcrumbs = [
      ["Dashboard", root_path],
      ["Todo List", tasks_path],
      ["New Task", nil]
    ]
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "Task was successfully updated."
    else
      render :show
    end
  end

  def update_is_done
    @breadcrumbs = [
      ["Dashboard", root_path],
      ["Todo List", nil]
    ]
    if @task.update(is_done: !@task.is_done)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to tasks_path, notice: "Task was updated." }
      end
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to tasks_path, notice: "Task was deleted." }
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.expect(task: [ :title, :description, :due_date, :important, :priority ])
  end
end
