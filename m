Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6523FEE99
	for <lists+kvm-ppc@lfdr.de>; Thu,  2 Sep 2021 15:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244365AbhIBNYy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm-ppc@lfdr.de>); Thu, 2 Sep 2021 09:24:54 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:44251 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234448AbhIBNYx (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 2 Sep 2021 09:24:53 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-179-p9qiScvWMG6-RCRrz6y5Wg-1; Thu, 02 Sep 2021 14:23:52 +0100
X-MC-Unique: p9qiScvWMG6-RCRrz6y5Wg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Thu, 2 Sep 2021 14:23:51 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Thu, 2 Sep 2021 14:23:51 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Fabiano Rosas' <farosas@linux.ibm.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
CC:     "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>
Subject: RE: [PATCH kernel] KVM: PPC: Book3S: Suppress warnings when
 allocating too big memory slots
Thread-Topic: [PATCH kernel] KVM: PPC: Book3S: Suppress warnings when
 allocating too big memory slots
Thread-Index: AQHXn/uuqy9zH8mqjEavl+BakB/R26uQuo6Q
Date:   Thu, 2 Sep 2021 13:23:51 +0000
Message-ID: <58cdff0ef02346f2990bddd526f08f34@AcuMS.aculab.com>
References: <20210901084512.1658628-1-aik@ozlabs.ru>
 <87fsuouysc.fsf@linux.ibm.com>
 <a72edcd2-a990-a549-2f31-dab134bef6a6@ozlabs.ru>
 <878s0funuy.fsf@linux.ibm.com>
In-Reply-To: <878s0funuy.fsf@linux.ibm.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

...
> > This is from my deep Windows past :)
> >
> > https://docs.microsoft.com/en-us/windows/win32/stg/coding-style-conventions
> 
> =D How interesting! And according to that link 'sz' means "Zero terminated
> String". Imagine the confusion.. haha

Is that document responsible for some of the general unreadability
of windows code?
(I'm not going to addle by brain by trying to read it.)

Types like DWORD_PTR really shouldn't exist.
You won't guess what it is...

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

