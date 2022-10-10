#pragma once
#include <vector>
#include <QObject>
#include <QUrl>
#include "book_operation_status.hpp"
#include "book.hpp"
#include "tag.hpp"


namespace application
{

class IBookService : public QObject
{
    Q_OBJECT
    
public:
    virtual ~IBookService() noexcept = default;
    
    virtual BookOperationStatus addBook(const QString& filePath) = 0;
    virtual BookOperationStatus deleteBook(const QString& title) = 0;
    virtual BookOperationStatus updateBook(const QString& title,
                                           const domain::models::Book& newBook) = 0;
    
    virtual const std::vector<domain::models::Book>& getBooks() const = 0;
    virtual const domain::models::Book* getBook(const QString& title) const = 0;
    virtual int getBookIndex(const QString& title) const = 0;
    virtual int getBookCount() const = 0;
    
    virtual BookOperationStatus addTag(const QString& title,
                                       const domain::models::Tag& tag) = 0;
    virtual BookOperationStatus removeTag(const QString& title, 
                                          const domain::models::Tag& tag) = 0;
    
    virtual BookOperationStatus saveBookToPath(const QString& title,
                                               const QUrl& path) = 0;
    
public slots:
    virtual bool refreshLastOpenedFlag(const QString& title) = 0;
    virtual void setAuthenticationToken(const QString& token) = 0;
    virtual void clearAuthenticationToken() = 0;
    
signals:
    void bookCoverGenerated(int index);
    void bookInsertionStarted(int index);
    void bookInsertionEnded();
    void bookDeletionStarted(int index);
    void bookDeletionEnded();
    void tagsChanged(int index);
    void dataChanged(int index);
};

} // namespace application