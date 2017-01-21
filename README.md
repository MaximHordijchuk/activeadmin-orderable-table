# Active Admin Orderable Table

This gem extends ActiveAdmin so that your index page's table rows can be 
orderable without page reloading via a drag-and-drop interface.

## Usage

### Add gem to your Gemfile

```ruby
gem 'sortable-rails'
gem 'activeadmin-orderable-table'
```

### Include the JavaScript in active_admin.js

```javascript
//= require sortable-rails
//= require activeadmin-orderable-table
```

### Include the Stylesheet in active_admin.css
```css
//= require activeadmin-orderable-table
```

### Configure your ActiveRecord model
You need to add an ordinal column to desired table:
```bash
rails g migration AddOrdinalToPage ordinal:integer
rake db:migrate
```

Then add following line to model that suppose to be orderable:
```ruby
acts_as_orderable_table
```

### Configure your ActiveAdmin Resource

```ruby
ActiveAdmin.register Page do
  config.sort_order = 'ordinal_asc'
  config.paginate = false # optional; drag-and-drop across pages is not supported

  orderable # creates the controller action which handles the ordering

  index do
    orderable_handle_column # inserts a drag handle
    # other columns...
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
