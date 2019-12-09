require 'nexus_api/docker_shell'

module NexusAPI
  class DockerManager

    def initialize(docker:, options:)
      @docker = docker
      @username = options['username']
      @password = options['password']
      @pull_host = options['pull_host']
      @push_host = options['push_host']
    end

    def download(image_name:, tag:)
      return false unless docker_valid?
      image_name = image_name(@pull_host, image_name, tag)
      begin
        image = @docker.pull_image(@username, @password, image_name)
      rescue Docker::Error::NotFoundError => error
        puts "ERROR: Failed to pull Docker image #{image_name}.\nDoes it exist in Nexus?"
        return false
      end
      true
    end

    def upload(image_name:, tag:)
      return false unless docker_valid?
      begin
        return false unless login
        image = find_image(image_name(@pull_host, image_name, tag))
        return false if image.nil?
        tag(image, @push_host, image_name, tag)
        image.push(nil, repo_tag: image_name(@push_host, image_name, tag))
      rescue StandardError => error
        puts "ERROR: #{error.inspect}"
        return false
      end
      true
    end

    def exists?(image_name:, tag:)
      return false unless docker_valid?
      images = find_images(image_name(@pull_host, image_name, tag))
      return false if images.empty?
      true
    end

    def delete(image_name:, tag:)
      return false unless docker_valid?
      begin
        image = find_image(image_name(@pull_host, image_name, tag))
        return false if image.nil?
        return false unless image.remove(:force => true)
      rescue StandardError => error
        puts "ERROR: #{error.inspect}"
        return false
      end
      true
    end

    private

    def docker_valid?
      return true if @docker.validate_version!
      puts 'ERROR: Your installed version of the Docker API is not supported by the docker-api gem!'
      false
    end

    def image_name(host, name, tag)
      "#{host}/#{name}:#{tag}"
    end

    def login
      return true if @docker.authenticate!(@username, @password, @push_host)
      puts "ERROR: Failed to authenticate to #{@push_host} as #{@username}"
      false
    end

    def find_images(name)
      @docker.list_images.select do |image|
        image.info['RepoTags'].include?(name)
      end
    end

    def valid?(images)
      if images.empty?
        puts 'ERROR: No matching docker images found'
        return false
      end
      if images.count > 1
        puts "ERROR: Found multiple images that match: #{images.map {|image| image.info['RepoTags']} }"
        return false
      end
      true
    end

    def find_image(name)
      images = find_images(name)
      if valid?(images)
        images.first
      else
        nil
      end
    end

    def tag(image, host, name, tag)
      unless image.info['RepoTags'].include?(image_name(host, name, tag))
        image.tag('repo'=>"#{host}/#{name}", 'tag'=>tag)
      end
    end
  end
end
