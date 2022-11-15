module LicensesHelper
  def filter_arrow
    if params[:sort].present?
      if params[:sort] == 'asc'
        return 'fa fa-arrow-down'
      else
        return 'fa fa-arrow-up'
      end
    end
  end
end
