#include "widget.h"
#include "ui_widget.h"

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);
    QString imageFile = QString("C:/WorkSpace/QTE/1/back.png");
    QImage *image = new QImage;
    image->load(imageFile);
    ui->back->setScaledContents(true);
    ui->back->setPixmap(QPixmap::fromImage(*image));
    QString bFile = QString("C:/WorkSpace/QTE/1/b.png");
    bimg = new QImage;
    bimg->load(bFile);
    QString wFile = QString("C:/WorkSpace/QTE/1/w.png");
    wimg = new QImage;
    wimg->load(wFile);
    for (auto f: ui->af->children())
        for (auto o: f->children())
        {
            QLabel *l = static_cast<QLabel *>(o);
            l->setScaledContents(true);
            l->setPixmap(QPixmap::fromImage(*bimg));
        }
    for (int i = 0; i < 8; i++)
        for (int j = 0; j < 8; j++)
            m[i][j] = true;
    mapper = new QSignalMapper;
    int i = 0, j = 0;
    for (auto f: ui->af->children())
    {
        for (auto o: f->children())
        {
            QLabelEx *l = static_cast<QLabelEx *>(o);
            connect(l, SIGNAL(clicked()), mapper, SLOT(map()));
            mapper->setMapping(l, i * 8 + j);
            j++;
        }
        i++;
        j = 0;
    }
    connect(mapper, SIGNAL(mapped(int)), this, SLOT(click(int)));
}

Widget::~Widget()
{
    delete ui;
}

void Widget::on_reset_clicked()
{
    for (auto f: ui->af->children())
        for (auto o: f->children())
        {
            QLabelEx *l = static_cast<QLabelEx *>(o);
            l->setScaledContents(true);
            l->setPixmap(QPixmap::fromImage(*bimg));
        }
    for (int i = 0; i < 8; i++)
        for (int j = 0; j < 8; j++)
            m[i][j] = true;
    return;
}

void Widget::click(int p)
{
    int x = p / 8;
    int y = p % 8;
    if (!m[x][y])
    {
        QMessageBox::warning(nullptr, QStringLiteral("警告"), QStringLiteral("白色"), QMessageBox::Yes, QMessageBox::Yes);
        return;
    }
    for (int j = 0; j < 8; j++)
        m[x][j] ^= true;
    for (int i = 0; i < 8; i++)
        m[i][y] ^= true;
    m[x][y] ^= true;
    display();
    return;
}

void Widget::display()
{
    int i = 0, j = 0;
    for (auto f: ui->af->children())
    {
        for (auto o: f->children())
        {
            QLabel *l = static_cast<QLabel *>(o);
            if (m[i][j])
                l->setPixmap(QPixmap::fromImage(*bimg));
            else
                l->setPixmap(QPixmap::fromImage(*wimg));
            j++;
        }
        i++;
        j = 0;
    }
}
