function OnFirm(firm)
    broadcastCallback("OnFirm", firm)
end

function OnAllTrade(alltrade)
    broadcastCallback("OnAllTrade", alltrade)
end

function OnTrade(trade)
    broadcastCallback("OnTrade", trade)
end

function OnOrder(order)
    broadcastCallback("OnOrder", order)
end

function OnAccountBalance(acc_bal)
    broadcastCallback("OnAccountBalance", acc_bal)
end

function OnFuturesLimitChange(fut_limit)
    broadcastCallback("OnFuturesLimitChange", fut_limit)
end

function OnFuturesLimitDelete(lim_del)
    broadcastCallback("OnFuturesLimitDelete", lim_del)
end

function OnFuturesClientHolding(fut_pos)
    broadcastCallback("OnFuturesClientHolding", fut_pos)
end

function OnMoneyLimit(mlimit)
    broadcastCallback("OnMoneyLimit", mlimit)
end

function OnMoneyLimitDelete(mlimit_del)
    broadcastCallback("OnMoneyLimitDelete", mlimit_del)
end

function OnDepoLimit(dlimit)
    broadcastCallback("OnDepoLimit", dlimit)
end

function OnDepoLimitDelete(dlimit_del)
    broadcastCallback("OnDepoLimitDelete", dlimit_del)
end

function OnAccountPosition(acc_pos)
    broadcastCallback("OnAccountPosition", acc_pos)
end

function OnNegDeal(neg_deals)
    broadcastCallback("OnNegDeal", neg_deals)
end

function OnNegTrade(neg_trade)
    broadcastCallback("OnNegTrade", neg_trade)
end

function OnStopOrder(stop_order)
    broadcastCallback("OnStopOrder", stop_order)
end

function OnTransReply(trans_reply)
    broadcastCallback("OnTransReply", trans_reply)
end

function OnParam(class_code, sec_code)
    broadcastCallback("OnParam", {
        class_code = class_code,
        sec_code = sec_code,
    })
end

function OnQuote(class_code, sec_code)
    broadcastCallback("OnQuote", {
        class_code = class_code,
        sec_code = sec_code,
    })
end

function OnDisconnected()
    broadcastCallback("OnDisconnected", {})
end

function OnConnected(flag)
    broadcastCallback("OnConnected", flag)
end

function OnCleanUp()
    broadcastCallback("OnCleanUp", {})
end