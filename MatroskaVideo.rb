#!/usr/bin/env ruby

require 'pathname'
require 'fileutils'
require 'rubygems'
require 'mkv'

class MatroskaVideo
	attr_reader	:input_file

	def initialize (input_file)
		@input_file = input_file
		@mkv = MKV::Movie.new(@input_file)
	end

	def to_s
		@mkv.tracks.each do |mkv|
			puts "#{mkv.number}: video, #{mkv.codec_id}, #{mkv.width}x#{mkv.height}" if mkv.type =~ /video/i
			puts "#{mkv.number}: audio, #{mkv.codec_id}, #{mkv.channels}" if mkv.type =~ /audio/i
			puts "#{mkv.number}: subtitles, #{mkv.codec_id}, #{mkv.default}, #{mkv.forced}" if mkv.type =~ /subtitles/i
		end
	end

	def is_high_definition?
		is_high_def = false
		@mkv.tracks.each do |mkv|
			is_high_def = true if mkv.type =~ /video/i and mkv.height >= 720
		end
		is_high_def
	end

	def has_lossless_audio?
		has_lossless_audio = false
		@mkv.tracks.each do |mkv|
			has_lossless_audio = true if mkv.codec_id =~ /{A_TRUEHD,A_DTS,A_PCM\/INT\/LIT}/i
		end
		has_lossless_audio
	end

	def has_stereo_aac?
		has_stereo_aac = false
		@mkv.tracks.each do |mkv|
			has_stereo_aac = true if mkv.codec_id =~ /A_AAC/i and mkv.channels == 2
		end
		has_stereo_aac
	end

	def has_forced_subs?
		has_forced_subs = false
		@mkv.tracks.each do |mkv|
			has_forced_subs = true if mkv.type =~ /subtitles/i and mkv.forced == true
		end
		has_forced_subs
	end

public
	def video_track_num
		track = 0
		@mkv.tracks.each do |mkv|
			track = mkv.number.to_i - 1 if mkv.type =~ /video/i
		end
		track
	end

	def dolby_track_num
		track = 0
		@mkv.tracks.each do |mkv|
			track = mkv.number.to_i - 1 if mkv.codec_id =~ /A_AC3/i
		end
		track
	end

	def aac_track_num
		track = 0
		@mkv.tracks.each do |mkv|
			track = mkv.number.to_i - 1 if mkv.codec_id =~ /A_AAC/i
		end
		track
	end
end

video = MatroskaVideo.new("/mnt/ladon/Media/Video/Movies/Harry Potter and the Sorcerer's Stone (2001).mkv")
puts video.has_forced_subs?
puts (nil || [0,0])[1] != 0