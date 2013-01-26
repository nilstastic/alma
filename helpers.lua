function wait (action,page)
    if page then
        while action:isBusy () and not page.exit do coroutine:yield () end
    else
        while action:isBusy () do coroutine:yield () end
    end
end