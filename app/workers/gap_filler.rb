class GapFiller
  include Sidekiq::Worker

  sidekiq_options(
    queue: :low,
    retry: false,
    lock: :until_and_while_executing,
    on_conflict: { client: :log, server: :reject },
  )

  def perform(prefix)
    nums = Movie.where("normalized_id ILIKE ?", "#{prefix}-%").pluck(:normalized_id).map { |id|
      id.split("-")[1].to_i
    }.reject(&:nil?).to_set
    return if nums.empty?
    1.upto(nums.max) do |i|
      MovieSearcher.perform_async("%s-%03d" % [prefix, i]) unless i.in? nums
    end
  end
end
