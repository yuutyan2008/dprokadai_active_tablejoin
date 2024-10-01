class ExercisesController < ApplicationController
  def exercise1
    # 【要件】注文されていないすべての料理を返すこと
    # 
    # foods テーブルと order_foods テーブルを左外部結合
    @foods = Food.left_outer_joins(:order_foods)
    # order_foods.food_id が NULL のレコード（注文されていない料理）を抽出
    .where(order_foods: { food_id: nil })
  end

  def exercise2
    # 【要件】注文されていない料理を提供しているすべてのお店を返すこと
    # 
    # shops テーブルを foods テーブルと左外部結合
    # foodsは直接関連付けられている最初のアソシエーション
    # order_foodsはfoodsに関連付けられている2番目のアソシエーション
    @shops = Shop.left_outer_joins(foods: :order_foods)
    # order_foods テーブルの id が nil（注文されていない料理）である行を抽出
    .where(order_foods: { id: nil })
    # 最終的に求めたいのはお店の名前だから重複を消去
    .distinct
  end

  def exercise3 
    # 【要件】配達先の一番多い住所を返すこと
    #   * 取得したAddressのインスタンスにorders_countと呼びかけると注文の数を返すこと
    #   
    # Address テーブルと orders テーブルを内部結合
    @address = Address.joins(:orders)
    #addresses テーブルの全てのカラムと、orders テーブルの各住所の注文数を orders_count として取得
    .select('addresses.*, COUNT(orders.id) AS orders_count')
    #addresses.id でグループ化することで、各住所ごとに注文数を集計
    .group('addresses.id')
    #orders_count の降順で並べ替える
    .order('orders_count DESC')
    .first
    @address = Address
  end

  def exercise4 
    # 【要件】一番お金を使っている顧客を返すこと
    #   * joinsを使うこと
    #   * 取得したCustomerのインスタンスにfoods_price_sumと呼びかけると合計金額を返すこと
    #   #customers テーブルと orders テーブルを結合し、さらに order_foods と foods テーブルを結合
    @customer = Customer.joins(orders: { order_foods: :food })
    #customers テーブルの全てのカラムと、各顧客が使った合計金額（foods.price の合計）を foods_price_sum として取得
    .select('customers.*, SUM(foods.price) AS foods_price_sum')
    #customers.id でグループ化
    .group('customers.id')
    #計金額を降順に並べ替え
    .order('foods_price_sum DESC')
    .first
  end
end
