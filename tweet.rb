require 'twitter'
require 'net/http'
require 'json'

LATITUDE = ENV['LATITUDE'].to_f
LONGITUDE = ENV['LONGITUDE'].to_f

class Pokemon
  attr_accessor :name, :distance, :rarity, :left_time

  POKEMONS = [
    "フシギダネ","フシギソウ","フシギバナ","ヒトカゲ","リザード","リザードン","ゼニガメ","カメール","カメックス","キャタピー","トランセル","バタフリー","ビードル","コクーン","スピアー","ポッポ","ピジョン","ピジョット","コラッタ","ラッタ","オニスズメ","オニドリル","アーボ","アーボック","ピカチュウ","ライチュウ","サンド","サンドパン","ニドラン♂","ニドリーナ","ニドクイン","ニドラン♀","ニドリーノ","ニドキング","ピッピ","ピクシー","ロコン","キュウコン","プリン","プクリン","ズバット","ゴルバット","ナゾノクサ","クサイハナ","ラフレシア","パラス","パラセクト","コンパン","モルフォン","ディグダ","ダグトリオ","ニャース","ペルシアン","コダック","ゴルダック","マンキー","オコリザル","ガーディ","ウインディ","ニョロモ","ニョロゾ","ニョロボン","ケーシィ","ユンゲラー","フーディン","ワンリキー","ゴーリキー","カイリキー","マダツボミ","ウツドン","ウツボット","メノクラゲ","ドククラゲ","イシツブテ","ゴローン","ゴローニャ","ポニータ","ギャロップ","ヤドン","ヤドラン","コイル","レアコイル","カモネギ","ドードー","ドードリオ","パウワウ","ジュゴン","ベトベター","ベトベトン","シェルダー","パルシェン","ゴース","ゴースト","ゲンガー","イワーク","スリープ","スリーパー","クラブ","キングラー","ビリリダマ","マルマイン","タマタマ","ナッシー","カラカラ","ガラガラ","サワムラー","エビワラー","ベロリンガ","ドガース","マタドガス","サイホーン","サイドン","ラッキー","モンジャラ","ガルーラ","タッツー","シードラ","トサキント","アズマオウ","ヒトデマン","スターミー","バリヤード","ストライク","ルージュラ","エレブー","ブーバー","カイロス","ケンタロス","コイキング","ギャラドス","ラプラス","メタモン","イーブイ","シャワーズ","サンダース","ブースター","ポリゴン","オムナイト","オムスター","カブト","カブトプス","プテラ","カビゴン","フリーザー","サンダー","ファイヤー","ミニリュウ","ハクリュー","カイリュー","ミュウツー","ミュウ"
  ].freeze
  RARITY = {"フシギダネ"=>4, "フシギソウ"=>-1, "フシギバナ"=>-1, "ヒトカゲ"=>4, "リザード"=>-1, "リザードン"=>-1, "ゼニガメ"=>4, "カメール"=>-1, "カメックス"=>-1, "キャタピー"=>6, "トランセル"=>-1, "バタフリー"=>-1, "ビードル"=>6, "コクーン"=>-1, "スピアー"=>-1, "ポッポ"=>6, "ピジョン"=>-1, "ピジョット"=>-1, "コラッタ"=>6, "ラッタ"=>-1, "オニスズメ"=>6, "オニドリル"=>-1, "アーボ"=>5, "アーボック"=>-1, "ピカチュウ"=>4, "ライチュウ"=>-1, "サンド"=>4, "サンドパン"=>-1, "ニドラン♂"=>5, "ニドリーナ"=>-1, "ニドクイン"=>-1, "ニドラン♀"=>5, "ニドリーノ"=>-1, "ニドキング"=>-1, "ピッピ"=>4, "ピクシー"=>-1, "ロコン"=>3, "キュウコン"=>-1, "プリン"=>4, "プクリン"=>-1, "ズバット"=>6, "ゴルバット"=>-1, "ナゾノクサ"=>6, "クサイハナ"=>-1, "ラフレシア"=>-1, "パラス"=>5, "パラセクト"=>-1, "コンパン"=>5, "モルフォン"=>-1, "ディグダ"=>4, "ダグトリオ"=>-1, "ニャース"=>4, "ペルシアン"=>-1, "コダック"=>4, "ゴルダック"=>-1, "マンキー"=>4, "オコリザル"=>-1, "ガーディ"=>4, "ウインディ"=>-1, "ニョロモ"=>5, "ニョロゾ"=>-1, "ニョロボン"=>-1, "ケーシィ"=>3, "ユンゲラー"=>-1, "フーディン"=>-1, "ワンリキー"=>3, "ゴーリキー"=>-1, "カイリキー"=>-1, "マダツボミ"=>5, "ウツドン"=>-1, "ウツボット"=>-1, "メノクラゲ"=>4, "ドククラゲ"=>-1, "イシツブテ"=>4, "ゴローン"=>-1, "ゴローニャ"=>-1, "ポニータ"=>4, "ギャロップ"=>-1, "ヤドン"=>4, "ヤドラン"=>-1, "コイル"=>4, "レアコイル"=>-1, "カモネギ"=>5, "ドードー"=>6, "ドードリオ"=>-1, "パウワウ"=>3, "ジュゴン"=>-1, "ベトベター"=>4, "ベトベトン"=>-1, "シェルダー"=>4, "パルシェン"=>-1, "ゴース"=>4, "ゴースト"=>-1, "ゲンガー"=>-1, "イワーク"=>4, "スリープ"=>4, "スリーパー"=>-1, "クラブ"=>5, "キングラー"=>-1, "ビリリダマ"=>5, "マルマイン"=>-1, "タマタマ"=>4, "ナッシー"=>-1, "カラカラ"=>4, "ガラガラ"=>-1, "サワムラー"=>2, "エビワラー"=>2, "ベロリンガ"=>3, "ドガース"=>4, "マタドガス"=>-1, "サイホーン"=>4, "サイドン"=>-1, "ラッキー"=>2, "モンジャラ"=>4, "ガルーラ"=>1, "タッツー"=>5, "シードラ"=>-1, "トサキント"=>5, "アズマオウ"=>-1, "ヒトデマン"=>5, "スターミー"=>-1, "バリヤード"=>1, "ストライク"=>3, "ルージュラ"=>4, "エレブー"=>2, "ブーバー"=>3, "カイロス"=>5, "ケンタロス"=>1, "コイキング"=>5, "ギャラドス"=>-1, "ラプラス"=>2, "メタモン"=>0, "イーブイ"=>4, "シャワーズ"=>-1, "サンダース"=>-1, "ブースター"=>-1, "ポリゴン"=>2, "オムナイト"=>2, "オムスター"=>-1, "カブト"=>2, "カブトプス"=>-1, "プテラ"=>2, "カビゴン"=>2, "フリーザー"=>0, "サンダー"=>0, "ファイヤー"=>0, "ミニリュウ"=>3, "ハクリュー"=>-1, "カイリュー"=>-1, "ミュウツー"=>0, "ミュウ"=>0}

  def initialize(hash)
    expiration_time = hash['expiration_time']
    @left_time = Time.at(expiration_time) - Time.now

    pokemon_id = hash['pokemonId']
    @name = POKEMONS[pokemon_id-1]
    @rarity = RARITY[@name]

    latitude = hash['latitude']
    longitude = hash['longitude']
    @distance = calc_distance(latitude, longitude)
  end

  def to_string
    "#{@name}: #{@distance.to_i}m #{@left_time.to_i}s"
  end

  private

  def calc_distance(lat, lng)
    y1 = lat * Math::PI / 180
    x1 = lng * Math::PI / 180
    y2 = LATITUDE * Math::PI / 180
    x2 = LONGITUDE * Math::PI / 180
    earth_r = 6378140
    deg = Math::sin(y1) * Math::sin(y2) + Math::cos(y1) * Math::cos(y2) * Math::cos(x2 - x1)
    distance = earth_r * (Math::atan(-deg / Math::sqrt(-deg * deg + 1)) + Math::PI / 2)
  end

  def <=>(pokemon)
    self.distance <=> pokemon.distance
  end
end

class PokemonsFetcher
  attr_accessor :pokemons

  SCAN_END_POINT = "https://pokevision.com/map/scan/#{LATITUDE}/#{LONGITUDE}"
  DATA_END_POINT = "https://pokevision.com/map/data/#{LATITUDE}/#{LONGITUDE}/"
  MAX_DISTANCE = ENV['MAX_DISTANCE'].to_f
  MAX_RARITY = ENV['MAX_RARITY'].to_f

  def initialize
    @pokemons = []
  end

  def fetch
    scan_uri = URI.parse(SCAN_END_POINT)
    scan_json = Net::HTTP.get(scan_uri)
    job_id = JSON.parse(scan_json)['jobId']

    sleep 3

    data_uri = URI.parse(DATA_END_POINT + job_id.to_s)
    data_json = Net::HTTP.get(data_uri)
    @pokemons = JSON.parse(data_json)['pokemon'].map { |e| Pokemon.new(e) }.select{|pokemon| pokemon.rarity <= MAX_RARITY && pokemon.distance < MAX_DISTANCE}.sort
  end
end

class PokemonTweet
  attr_accessor :tweet

  def initialize
    @cli = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
    @screen_name = @cli.user.screen_name
  end

  def update
    pokemons = PokemonsFetcher.new.fetch.uniq{|p| p.name}
    return if pokemons.empty?
    sentence = "@#{@screen_name} #{ENV['PLACE_NAME']}近くにいるレアポケモンは\n#{pokemons[0...5].map(&:to_string).join("\n")}\nだよ！"
    @cli.update(sentence)
  end
end
