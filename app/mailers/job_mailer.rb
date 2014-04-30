
# The mailer for jobs, e.g. to send activation emails out
# or to notify of applications to jobs
class JobMailer < ActionMailer::Base
  default_url_options[:host] = ROOT_URL
  default :from => "Berkeley BeeHive <beehive-support@lists.berkeley.edu>"

  def activate_job_email(job)
    @job = job
    @faculty_sponsor_names = job.faculties.collect(&:name).join(", ")

    mail(:to => job.faculties.collect(&:email),
         :subject => "Project Listing Confirmation | Berkeley BeeHive")
  end

  def deliver_applic_email(applic, user_email, faculty_emails)
    @applic = applic
    @job = applic.job

    [:resume, :transcript].each do |doctype|
      if @applic.send(doctype).present?
       attachments[@applic.user.name + '_' + doctype.to_s + '.' +
         @applic.send(doctype).public_filename.split('.').last] =
         File.read(@applic.send(doctype).public_filename)
      end
    end

    mail(:to => [user_email] | faculty_emails,
         :subject => "[BeeHive] Project Application")
  end
end
