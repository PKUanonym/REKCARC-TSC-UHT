#include "mybuttongroup.h"

void my_button::unlockAndStayTop()
{
    setWindowOpacity(1);
    setWindowFlags(0);
    show();
    raise();

    if (window_long == 0)
    {
        window_long = GetWindowLong((HWND)this->winId(), GWL_EXSTYLE);
    }
    SetWindowLong((HWND)this->winId(), GWL_EXSTYLE, window_long);
}

void my_button::lockAndStayBottom()
{
    setWindowOpacity(0.5);
    setWindowFlags(Qt::FramelessWindowHint | Qt::Tool | Qt::WindowStaysOnBottomHint);
    show();
    lower();
    SetWindowLong((HWND)this->winId(), GWL_EXSTYLE, window_long | WS_EX_TRANSPARENT | WS_EX_LAYERED);
}

void my_checkbox::unlockAndStayTop()
{
    setWindowOpacity(1);
    setWindowFlags(0);
    show();
    raise();

    if (window_long == 0)
    {
        window_long = GetWindowLong((HWND)this->winId(), GWL_EXSTYLE);
    }
    SetWindowLong((HWND)this->winId(), GWL_EXSTYLE, window_long);
}

void my_checkbox::lockAndStayBottom()
{
    setWindowOpacity(0.5);
    setWindowFlags(Qt::FramelessWindowHint | Qt::Tool | Qt::WindowStaysOnBottomHint);
    show();
    lower();
    SetWindowLong((HWND)this->winId(), GWL_EXSTYLE, window_long | WS_EX_TRANSPARENT | WS_EX_LAYERED);
}

void my_radio::unlockAndStayTop()
{
    setWindowOpacity(1);
    setWindowFlags(0);
    show();
    raise();

    if (window_long == 0)
    {
        window_long = GetWindowLong((HWND)this->winId(), GWL_EXSTYLE);
    }
    SetWindowLong((HWND)this->winId(), GWL_EXSTYLE, window_long);
}

void my_radio::lockAndStayBottom()
{
    setWindowOpacity(0.5);
    setWindowFlags(Qt::FramelessWindowHint | Qt::Tool | Qt::WindowStaysOnBottomHint);
    show();
    lower();
    SetWindowLong((HWND)this->winId(), GWL_EXSTYLE, window_long | WS_EX_TRANSPARENT | WS_EX_LAYERED);
}
