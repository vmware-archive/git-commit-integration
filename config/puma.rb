# config/puma.rb
threads 8,32
workers 3

preload_app!

on_worker_boot do
  # things workers do
end
