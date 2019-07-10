class IndexHeatmapMetric < IndexMetric

  belongs_to :heatmap

  field :type, type: String, default: 'heatmap'

end
