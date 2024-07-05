module Admin
  class UsersController < BaseController
    before_action :prepare_employee_list, only: [:index]
    before_action :prepare_employee, except: [:create, :new, :index]

    def index; end

    def new
      @employee = User.new
      @employee.add_role :user
    end

    def create
      @employee = User.create(new_employee_params)
      if @employee.save
        redirect_to admin_users_path, notice: 'Employee was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @employee.update(update_employee_params)
        redirect_to admin_users_path, notice: 'Employee was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @employee.destroy
      redirect_to admin_users_path, notice: 'Employee was successfully deleted.'
    end

    def ban
      @employee.update(active: false)
      redirect_to admin_users_path, notice: 'Employee was successfully banned.'
    end

    def unban
      @employee.update(active: true)
      redirect_to admin_users_path, notice: 'Employee was successfully unclocked.'
    end

    private

    def prepare_employee_list
      @employees = User.includes([:roles]).all
    end

    def prepare_employee
      @employee = User.find(params[:id])
    end

    def new_employee_params
      params.require(:user).permit(:email, :role_ids, :password, :active, :first_name, :last_name)
    end

    def update_employee_params
      params.require(:user).permit(:email, :role_ids, :active, :first_name, :last_name)
    end
  end
end
