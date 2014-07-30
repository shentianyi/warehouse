class ReportsController < ApplicationController
	def report

	end

	private

	def set_report_parameter
		@location = p[:location]
		
	end
end
