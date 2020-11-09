module ErrorHelper
    def show_errors_for(object)
        render partial: "/shared/errors", locals: {object: object}  
    end  
end 

# When we render a form partial the path that we pass doesn't include the underscore in the file name 
# _errors => /errors 