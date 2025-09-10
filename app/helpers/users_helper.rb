module UsersHelper
    def role_display(role)
        case role
        when 1
            { name: 'Admin', css_class: 'danger' }
        when 2
            { name: 'Manager', css_class: 'warning' }
        when 3
            { name: 'Member', css_class: 'primary' }
        else
            { name: 'Unknow', css_class: 'dark' }
        end
    end
end
