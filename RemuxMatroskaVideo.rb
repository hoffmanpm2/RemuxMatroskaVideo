#!/usr/bin/env ruby

require 'fileutils'
require_relative 'MatroskaVideo'

input_file = ARGV[0].strip if !ARGV.empty?
if !input_file.nil? and !input_file.empty?
	output_path = Pathname.new(input_file).dirname.sub(/\/Video/) { "/Video/Archive" }
	output_file = Pathname.new(input_file).basename.sub(/\.mkv$/) { ".mp4" }
	if !File.exists?("#{output_path}/#{output_file}")
		video = MatroskaVideo.new(input_file) if File.exists?(input_file)
		ffmpeg_binary="/usr/bin/ffmpeg"

		if Dir[output_path] == []
			FileUtils.mkpath(output_path)
		end

		if !video.has_forced_subs?
			if video.is_high_definition?
				if video.has_lossless_audio?
					if video.has_stereo_aac?
						ffmpeg_opts = "-i \"#{input_file}\" -vcodec copy -acodec copy -acodec copy -map 0:#{video.video_track_num} -map 0:#{video.dolby_track_num} -map 0:#{video.aac_track_num} -f mp4 -o \"#{output_path}/#{output_file}\""
						ffmpeg_cmd = "#{ffmpeg_binary} #{ffmpeg_opts}"
						puts "#{ffmpeg_cmd}"
						#output = Open3.popen3 (ffmpeg_cmd) { |stdin, stdout, stderr| stdout.read }
					else
						ffmpeg_opts = "-i \"#{input_file}\" -vcodec copy -acodec copy -acodec copy -map 0:#{video.video_track_num} -map 0:#{video.dolby_track_num} -map 0:#{video.aac_track_num} -f mp4 -o \"#{output_path}/#{output_file}\""
						ffmpeg_cmd = "#{ffmpeg_binary} #{ffmpeg_opts}"
						puts "#{ffmpeg_cmd}"
						#output = Open3.popen3 (ffmpeg_cmd) { |stdin, stdout, stderr| stdout.read }
					end
				end
			else
				ffmpeg_opts = "-i \"#{input_file}\" -vcodec copy -acodec copy -acodec copy -map 0:#{video.video_track_num} -map 0:#{video.dolby_track_num} -map 0:#{video.aac_track_num} -f mp4 -o \"#{output_path}/#{output_file}\""
				ffmpeg_cmd = "#{ffmpeg_binary} #{ffmpeg_opts}"
				puts "#{ffmpeg_cmd}"
				#output = Open3.popen3 (ffmpeg_cmd) { |stdin, stdout, stderr| stdout.read }
			end
		else
			puts Pathname.new(input_file).basename.to_s + " has forced subtitles. It cannot be remuxed."
		end
	end
else
	puts "Syntax: RemuxMatroskaVideo <file>"
end