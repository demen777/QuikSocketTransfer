function OnFirm(firm)
    sendCallback("OnFirm", firm)
end

function OnAllTrade(alltrade)
    sendCallback("OnAllTrade", alltrade)
end

function OnTrade(trade)
    sendCallback("OnTrade", trade)
end

function OnOrder(order)
    sendCallback("OnOrder", order)
end

function OnAccountBalance(acc_bal)
    sendCallback("OnAccountBalance", acc_bal)
end

function OnFuturesLimitChange(fut_limit)
    sendCallback("OnFuturesLimitChange", fut_limit)
end

function OnFuturesLimitDelete(lim_del)
    sendCallback("OnFuturesLimitDelete", lim_del)
end

function OnFuturesClientHolding(fut_pos)
    sendCallback("OnFuturesClientHolding", fut_pos)
end

function OnMoneyLimit(mlimit)
    sendCallback("OnMoneyLimit", mlimit)
end

function OnMoneyLimitDelete(mlimit_del)
    sendCallback("OnMoneyLimitDelete", mlimit_del)
end

function OnDepoLimit(dlimit)
    sendCallback("OnDepoLimit", dlimit)
end

function OnDepoLimitDelete(dlimit_del)
    sendCallback("OnDepoLimitDelete", dlimit_del)
end

function OnAccountPosition(acc_pos)
    sendCallback("OnAccountPosition", acc_pos)
end

function OnNegDeal(neg_deals)
    sendCallback("OnNegDeal", neg_deals)
end

function OnNegTrade(neg_trade)
    sendCallback("OnNegTrade", neg_trade)
end

function OnStopOrder(stop_order)
    sendCallback("OnStopOrder", stop_order)
end

function OnTransReply(trans_reply)
    sendCallback("OnTransReply", trans_reply)
end

function OnParam(class_code, sec_code)
    sendCallback("OnParam", {
        class_code = class_code,
        sec_code = sec_code,
    })
end

function OnQuote(class_code, sec_code)
    sendCallback("OnQuote", {
        class_code = class_code,
        sec_code = sec_code,
    })
end

function OnDisconnected()
    sendCallback("OnDisconnected", {})
end

function OnConnected(flag)
    sendCallback("OnConnected", flag)
end

function OnCleanUp()
    sendCallback("OnCleanUp", {})
end