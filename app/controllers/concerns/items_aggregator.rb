module ItemsAggregator
  extend ActiveSupport::Concern

  def aggregate_and_paginate(fanza_query, mgstage_query, javlibrary_query)
    ids = (fanza_query.distinct.pluck(:normalized_id) +
           mgstage_query.distinct.pluck(:normalized_id) +
           javlibrary_query.distinct.pluck(:normalized_id)).sort.uniq
    paginiated_ids = Kaminari::paginate_array(ids).page(params[:page]).per(30)
    items = paginiated_ids.map { |id|
      FanzaItem.find_by(normalized_id: id) ||
        MgstageItem.find_by(normalized_id: id) ||
        JavlibraryItem.find_by(normalized_id: id)
    }
    Kaminari::paginate_array(items, total_count: ids.count).page(params[:page]).per(30)
  end
end
