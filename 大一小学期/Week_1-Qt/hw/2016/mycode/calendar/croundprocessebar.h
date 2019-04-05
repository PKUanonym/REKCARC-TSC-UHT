#ifndef CROUNDPROCESSBAR_H
#define CROUNDPROCESSBAR_H
#include <QProgressBar>
#include <QPainter>
#include <QDebug>
class CRoundProcesseBar : public QProgressBar

{

Q_OBJECT




public:

CRoundProcesseBar(QWidget *parent = 0);

~CRoundProcesseBar();




void setScanValue(QString strValue);




QString m_strValue;




private:

qreal m_value;

qreal m_outerRadius;

qreal m_innerRadius;

qreal m_colorPieRadius;

qreal m_coverCircleRadius;

//qreal m_currentValue;

//qreal m_longHand;

//qreal m_okHand;

//qreal m_shortHand;

qreal m_space;

//bool m_bReverse;

//QTimer* updateTimer;

QPointF m_center;

QRectF m_pieRect;




private:

void drawOuterCircle(QPainter* painter);

void drawInnerCircle(QPainter* painter);

void drawColorPies(QPainter* painter, QString strValue);

void drawCoverLines(QPainter* painter);

void drawCoverCircle(QPainter* painter);

void drawMarkAndText(QPainter* painter);

void drawGraph(QPainter* painter);

void drawTextRect(QPainter* painter);

void resetVariables(QPainter* painter);




protected:

void paintEvent(QPaintEvent *event);

};


#endif // CROUNDPROCESSBAR_H
