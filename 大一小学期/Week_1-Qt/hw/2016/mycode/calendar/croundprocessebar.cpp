#include "croundprocessebar.h"

CRoundProcesseBar::CRoundProcesseBar(QWidget *parent)

: QProgressBar(parent)

{


m_outerRadius=width()>height() ? height()/2 : width()/2;

m_innerRadius=0.8*m_outerRadius;

m_colorPieRadius=m_outerRadius*0.7;

m_coverCircleRadius=0.7*m_colorPieRadius;

m_center=rect().center();

//m_longHand=(qreal)m_outerRadius/20;

//m_okHand=0.7*m_longHand;

//m_shortHand=0.5*m_longHand;

//m_space=0.1*m_longHand;


this->setFixedSize(100,100);

setScanValue("0");

}


CRoundProcesseBar::~CRoundProcesseBar()

{


}


void CRoundProcesseBar::setScanValue(QString strValue)

{

m_strValue = strValue;

this->repaint();

}


void CRoundProcesseBar::resetVariables(QPainter *painter)

{

m_outerRadius=width()>height() ? height()/2 : width()/2;

m_innerRadius=0.8*m_outerRadius;

m_center=rect().center();

m_colorPieRadius=m_outerRadius*0.7;

m_coverCircleRadius=0.7*m_colorPieRadius;

//m_longHand=(qreal)m_outerRadius/20;

//m_okHand=0.7*m_longHand;

// m_shortHand=0.5*m_longHand;

//m_space=0.1*m_longHand;

}


void CRoundProcesseBar::paintEvent(QPaintEvent *event)

{

QPainter painter;

painter.begin(this);

painter.setRenderHints(QPainter::Antialiasing|QPainter::TextAntialiasing);


resetVariables(&painter);

drawInnerCircle(&painter);

drawColorPies(&painter,m_strValue);

drawTextRect(&painter);


painter.end();

}


void CRoundProcesseBar::drawOuterCircle(QPainter* painter)

{

painter->save();


QRadialGradient outerGradient(m_center,m_outerRadius,m_center);

outerGradient.setColorAt(0.0,QColor(220,220,220));

outerGradient.setColorAt(0.4,QColor(220,220,220));

outerGradient.setColorAt(0.5,QColor(240,240,240));

outerGradient.setColorAt(1.0,QColor(220,220,220));


QPen pen;

pen.setColor(Qt::gray);

pen.setWidth(1);

painter->setPen(pen);

painter->setBrush(outerGradient);

painter->drawEllipse(m_center,m_outerRadius,m_outerRadius);


painter->restore();

}


void CRoundProcesseBar::drawInnerCircle(QPainter* painter)

{

painter->save();


QRadialGradient innerGradient(m_center,m_innerRadius,m_center);

innerGradient.setColorAt(0.0,QColor(240,240,240));

innerGradient.setColorAt(1.0,QColor(220,220,220));


painter->setPen(Qt::NoPen);

painter->setBrush(innerGradient);

painter->drawEllipse(m_center,m_innerRadius,m_innerRadius);


painter->restore();

}


void CRoundProcesseBar::drawColorPies(QPainter* painter, QString strValue)

{
qDebug("%d",strValue.toInt());
painter->save();

painter->setPen(Qt::NoPen);

QPointF pieRectTopLeftPot(m_center.x()-m_colorPieRadius,m_center.y()-m_colorPieRadius);

QPointF pieRectBottomRightPot(m_center.x()+m_colorPieRadius,m_center.y()+m_colorPieRadius);


m_pieRect=QRectF(pieRectTopLeftPot,pieRectBottomRightPot);

//draw green pie


if(strValue.toInt() >= 80)

{

painter->setBrush(Qt::green);

}

else

{

painter->setBrush(Qt::red);

}


float fAngle = strValue.toFloat();

double nPieLenth = 360 - 360 *(fAngle/100.0) - 360;

painter->drawPie(m_pieRect,90*16, nPieLenth*16);

painter->restore();

}


void CRoundProcesseBar::drawGraph(QPainter* painter)

{

qreal increment=(qreal)180/100;

painter->save();

painter->setPen(Qt::NoPen);


QRadialGradient graphGradient(m_center,m_colorPieRadius,m_center);

graphGradient.setColorAt(0.0,QColor(255,255,255));

graphGradient.setColorAt(0.7,QColor(255,255,255));

graphGradient.setColorAt(0.85,QColor(255,255,255));

graphGradient.setColorAt(1.0,QColor(255,255,255));

painter->setBrush(graphGradient);

painter->drawPie(m_pieRect,90,360*16);


painter->restore();

}


void CRoundProcesseBar::drawTextRect(QPainter* painter)

{

painter->save();

painter->setOpacity(0.7);

QPointF topLeftPot(m_center.x()-m_coverCircleRadius,m_center.y()-m_coverCircleRadius);

QPointF bottomRightPot(m_center.x()+m_coverCircleRadius,m_center.y()+m_coverCircleRadius);

QRectF textRect(topLeftPot,bottomRightPot);

painter->setPen(Qt::NoPen);


QRadialGradient outerGradient(m_center,m_coverCircleRadius,m_center);

outerGradient.setColorAt(0.0,QColor(220,220,220));

outerGradient.setColorAt(0.5,QColor(220,220,220));

outerGradient.setColorAt(0.8,QColor(240,240,240));

outerGradient.setColorAt(1.0,QColor(220,220,220));


QPen pen;

pen.setColor(QColor(200,200,200,255));

pen.setWidth(1);

painter->setPen(pen);

painter->setBrush(outerGradient);

painter->drawEllipse(m_center, m_coverCircleRadius, m_coverCircleRadius);


painter->setOpacity(1.0);

painter->setPen(Qt::red);

qreal fontSize=m_coverCircleRadius * 0.8;

QFont font;

font.setPointSize(fontSize);

font.setBold(true);

painter->setFont(font);

painter->drawText(textRect,Qt::AlignVCenter|Qt::AlignHCenter, m_strValue);

painter->restore();

}
