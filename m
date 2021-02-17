Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E88331E2E2
	for <lists+kvm-ppc@lfdr.de>; Thu, 18 Feb 2021 00:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhBQXBk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 17 Feb 2021 18:01:40 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:16785 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhBQXBk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 17 Feb 2021 18:01:40 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602da02b0005>; Wed, 17 Feb 2021 15:00:59 -0800
Received: from nvdebian.localnet (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 17 Feb
 2021 23:00:56 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     <linux-mm@kvack.org>
CC:     Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Nouveau Dev" <nouveau@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <kvm-ppc@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH 0/9] Add support for SVM atomics in Nouveau
Date:   Thu, 18 Feb 2021 10:00:54 +1100
Message-ID: <6616185.Wbe1NtApLk@nvdebian>
In-Reply-To: <20210211075510.GA2368090@infradead.org>
References: <20210209010722.13839-1-apopple@nvidia.com> <20210210175913.GO4718@ziepe.ca> <20210211075510.GA2368090@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613602859; bh=Zcp6FwQOo6uCl+bAC2DWEr4Viwiu5nIBT+YN6D2qruU=;
        h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
         MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=AXb+ut3ot7Odaa4NfndUdnHlBWh/CmCbxa90e7XGqYDqOl0itTA0ey/0xdqSoXbA2
         JlMNydOcVXGiAO1uyIryQXCh6IJNMB5+ajbf7PvbtDcER0T/TTnEqkgpU2USIY0Ya+
         NqYaHlrJc7yam1VcZFkBNUvumzVGyvnQedJAd2+hs20Ac8NKfjzT6p3t31zwxNt/Hq
         gR+sHNOCuxdnohI6TOW7pnPo+iGVNWMyVlv0cNOIZszQSsdsXR69vsDcRIyKwiHLuU
         QHMPy9U3pXXKcoKf2xltHJbe92pWiS2sWG6fQJuE1wnVVzjgSmr5R0ufLguVI0LbOK
         oydiyGx+ixcIg==
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thursday, 11 February 2021 6:55:10 PM AEDT Christoph Hellwig wrote:
> On Wed, Feb 10, 2021 at 01:59:13PM -0400, Jason Gunthorpe wrote:
> > Really what you want to do here is leave the CPU page in the VMA and
> > the page tables where it started and deny CPU access to the page. Then
> > all the proper machinery will continue to work.
> > 
> > IMHO "migration" is the wrong idea if the data isn't actually moving.
> 
> Agreed.
 
I chose "migration" because device private pages seemed like a good way of 
reusing existing code to do what was required (a callback on CPU access).

However I have been reworking this to use mmu notifiers as the callback and it 
seems to simplify some things nicely so think I also agree. It removes the 
requirement for the pin as well which is nice, I'll post it as a v2 soon.

 - Alistair



