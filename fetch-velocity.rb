require "json"
require "open-uri"

class VelocityVersion
  PAPER_API = "https://papermc.io/api/v2"

  attr_reader :build_info, :version

  def initialize(version)
    if match = version.match(/(?<version>[\d\.]+-SNAPSHOT)-(?<build>\d+)/)
      @version  = match[:version]
      @build    = match[:build]
    else
      @version  = version
    end
  end

  def download_path
    if has_builds?
      @build_info = get_build_info(@build) || get_latest_promoted_build || get_build_info(build_numbers.last)
      return get_download_path_for_build(build_info)
    end
  end

  def has_builds?
    version_info["builds"] && version_info["builds"].length > 0
  end

  def version_info
    @version_info ||= fetch("/projects/velocity/versions/#{version}")
  end

  private

  def get_latest_promoted_build
    build_numbers.reverse.each do |build_number|
      build_info = get_build_info(build_number)
      return build_info if build_info["promoted"]
    end

    return false
  end

  def get_build_info(build_number)
    build_number && fetch("/projects/velocity/versions/#{version}/builds/#{build_number}")
  end

  def get_download_path_for_build(build_info)
    version   = build_info["version"]
    build     = build_info["build"]
    filename  = build_info["downloads"]["application"]["name"]
    "#{PAPER_API}/projects/velocity/versions/#{version}/builds/#{build}/downloads/#{filename}"
  end

  def fetch(path)
    JSON.parse(URI("#{PAPER_API}#{path}").read)
  rescue OpenURI::HTTPError
    {}
  end

  def build_numbers
    @build_numbers ||= version_info["builds"]
  end
end

version = VelocityVersion.new(ARGV[0])
if !version.has_builds?
  $stderr.puts "Could not find builds for version #{version.version} of Velocity!"
  exit 1
end

if download_path = version.download_path
  `wget -O velocity.jar #{download_path}`
  puts "Downloaded #{version.version} build #{version.build_info["build"]} to velocity.jar"
else
  $stderr.puts "Could not retrieve download path for #{version.version}}!"
  exit 1
end