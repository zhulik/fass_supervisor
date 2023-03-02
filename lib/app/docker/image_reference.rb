# frozen_string_literal: true

class App::Docker::ImageReference
  DEFAULT_REGISTRY = "docker.io"
  DEFAULT_TAG = "latest"
  DEFAULT_OWNER = "library"

  attr_reader :registry, :owner, :name, :tag, :digest, :version_suffix

  def initialize(name)
    @registry = DEFAULT_REGISTRY
    @owner = DEFAULT_OWNER

    parse(name)
  end

  def to_s(*) = "#{registry}/#{owner}/#{name}#{version_suffix}"

  private

  def parse(name)
    name.then { parse_tag_or_digest!(_1) }
        .then { parse_name!(_1) }
  end

  def parse_tag_or_digest!(name)
    case name.split("@")
    in [name, digest]
      @digest = digest
      return name
    else
    end

    case name.split(":")
    in [name, tag]
      @tag = tag
      return name
    in [name]
      @tag = DEFAULT_TAG
      return name
    end
  end

  def parse_name!(name)
    case name.split("/")
    in [name] then @name = name
    in [owner, name]
      @owner = owner
      @name = name
    in [registry, owner, name]
      @registry = registry
      @owner = owner
      @name = name
    end
    @version_suffix = digest ? "@#{digest}" : ":#{tag}"
  end
end
