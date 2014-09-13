script "apt-get-update" do
  interpreter "bash"
  code <<-EOH
  sudo apt-get update || echo "Couldn't update package tree -- continuing"
  EOH
end

