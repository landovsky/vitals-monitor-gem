# frozen_string_literal: true

namespace :vitals_monitor do
  desc "Generate initializer file for VitalsMonitor"
  task :install do
    require "fileutils"

    initializer_path = File.join(Dir.pwd, "config", "initializers", "vitals_monitor.rb")

    # Check if we're in a Rails app
    config_dir = File.join(Dir.pwd, "config")
    application_rb = File.join(config_dir, "application.rb")
    routes_rb = File.join(config_dir, "routes.rb")

    unless File.directory?(config_dir) && (File.exist?(application_rb) || File.exist?(routes_rb))
      puts "Error: This doesn't appear to be a Rails application."
      puts "Please run this task from your Rails application root directory."
      exit 1
    end

    # Create initializers directory if it doesn't exist
    FileUtils.mkdir_p(File.dirname(initializer_path))

    # Check if initializer already exists
    if File.exist?(initializer_path)
      puts "Initializer already exists at #{initializer_path}"
      puts "Skipping generation. Delete the file first if you want to regenerate it."
      exit 0
    end

    # Generate initializer content
    initializer_content = <<~RUBY
      # frozen_string_literal: true

      VitalsMonitor.configure do |config|
        # Enable or disable specific components
        # By default, all components are enabled
        config.enable(:postgres)
        config.enable(:redis)
        config.enable(:sidekiq)

        # Or disable specific components
        # config.disable(:sidekiq)
      end
    RUBY

    # Write the initializer file
    File.write(initializer_path, initializer_content)

    puts "✓ Generated initializer at #{initializer_path}"

    # Add mount statement to routes.rb (host app's routes, not gem's routes)
    mount_statement = "  mount VitalsMonitor::Engine => '/vitals'"
    mount_pattern = /mount\s+VitalsMonitor::Engine/

    if File.exist?(routes_rb)
      routes_content = File.read(routes_rb)

      # Skip if this is the gem's own routes file (contains VitalsMonitor::Engine.routes.draw)
      if routes_content.include?("VitalsMonitor::Engine.routes.draw")
        puts "⚠ Skipping routes modification (detected gem's routes file)"
        puts "   Please manually add to your Rails app's config/routes.rb:"
        puts "   #{mount_statement.strip}"
      # Check if mount statement already exists
      elsif routes_content.match?(mount_pattern)
        puts "✓ Mount statement already exists in #{routes_rb}"
      else
        # Add mount statement after Rails.application.routes.draw do
        if routes_content.include?("Rails.application.routes.draw do")
          routes_content.gsub!(/(Rails\.application\.routes\.draw\s+do)/, "\\1\n#{mount_statement}")
          File.write(routes_rb, routes_content)
          puts "✓ Added mount statement to #{routes_rb}"
        # Handle alternative route file formats
        elsif routes_content.include?("routes.draw do") && !routes_content.include?("VitalsMonitor::Engine")
          routes_content.gsub!(/(routes\.draw\s+do)/, "\\1\n#{mount_statement}")
          File.write(routes_rb, routes_content)
          puts "✓ Added mount statement to #{routes_rb}"
        # If no draw block found, add it at the end
        else
          routes_content += "\n#{mount_statement}\n"
          File.write(routes_rb, routes_content)
          puts "✓ Added mount statement to #{routes_rb}"
        end
      end
    else
      puts "⚠ Warning: Could not find #{routes_rb}"
      puts "   Please manually add: #{mount_statement.strip}"
    end

    puts ""
    puts "Setup complete! Customize the configuration in #{initializer_path} if needed."
  end
end
