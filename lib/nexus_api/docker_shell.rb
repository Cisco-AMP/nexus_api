require 'docker'

module NexusAPI
  class DockerShell
    def validate_version!
      Docker.validate_version!
    end

    def pull_image(username, password, image_name)
      Docker::Image.create(
        'username' => username,
        'password' => password,
        'fromImage' => image_name
      )
    rescue Docker::Error::ClientError => error
      puts "Error: Could not pull Docker image '#{image_name}'"
      puts error
    end

    def authenticate!(username, password, host)
      Docker.authenticate!(
        'username' => username,
        'password' => password,
        'serveraddress' => host
      )
    end

    def list_images
      Docker::Image.all
    end
  end
end