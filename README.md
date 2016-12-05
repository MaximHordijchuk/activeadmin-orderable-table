# Active Admin Ordinal

This gem extends ActiveAdmin so that your index page's table rows can be 
ordinal via a drag-and-drop interface.

## Usage

### Add gem to your Gemfile

```ruby
gem 'activeadmin-ordinal'
```

### Include the JavaScript in active_admin.js

```javascript
//= require sortable-rails
//= require activeadmin-ordinal
```

### Include the Stylesheet in active_admin.css
```css
//= require activeadmin-ordinal
```

### Configure your ActiveRecord model
You need to add an ordinal column to desired table:
```bash
rails g migration AddOrdinalToPage ordinal:integer
rake db:migrate
```

Then add following line to model that suppose to be ordinal:
```ruby
acts_as_ordinal
```

### Configure your ActiveAdmin Resource

```ruby
ActiveAdmin.register Page do
  config.sort_order = 'ordinal_asc'
  config.paginate = false # optional; drag-and-drop across pages is not supported

  ordinal # creates the controller action which handles the ordering

  index do
    ordinal_handle_column # inserts a drag handle
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
