class ReportsController < ApplicationController
	def entry_report

	end

	private

	def set_report_parameter
		@location = p[:location]
		
	end
end
