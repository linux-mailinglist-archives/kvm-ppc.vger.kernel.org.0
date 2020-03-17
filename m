Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4E4188C29
	for <lists+kvm-ppc@lfdr.de>; Tue, 17 Mar 2020 18:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgCQRcS (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 17 Mar 2020 13:32:18 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38893 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgCQRcS (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 17 Mar 2020 13:32:18 -0400
Received: by mail-qt1-f194.google.com with SMTP id e20so18192743qto.5
        for <kvm-ppc@vger.kernel.org>; Tue, 17 Mar 2020 10:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Q/uuGRZEOsDl+bE2n4dBjQindS2U+dSkshg9e/3rsJY=;
        b=FU4iUBgbL/YDOzKu+bjTnxXn9TflPig4spFWJmilzk34kRefbe53ABssDpnYq4RxiZ
         n+O0F9b3g0saj53WHsCNw5lj/7/hY9KDJgPbxFKg1RV/01pre5JdZmlAkXMNQHxWapmi
         GprzttsXWQT9FXf/jK4VEXwggJDPRtExDhINmyI8LiapOrpi52Hmxmp/qtYxgvT0ClFa
         00xf+UmfedAWNC5qQzvH5yQdL0FIMlujhU3Kt/3E0lniCZy7MVtlf7dJy6MDyLvq5A+d
         NsyuTABobaFq0uYwqJPFhHf545MhX77WFDFIuE4jQpUv4U9urn5L79qq79pmeF23Wts7
         R4jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Q/uuGRZEOsDl+bE2n4dBjQindS2U+dSkshg9e/3rsJY=;
        b=CVzrk3qLxBnIQ+nhAHvr50BPepLQ2+ZKdJXxdC45jdjXZew0B7FWB/44g9zapgYLqu
         n/SVIYPEl/M8MhuFIKXEK+8tKdtGCD+naia+rcrSwMApa1WSx28ARfu0T41W7rDCeLID
         Z38xOVE7VAv77w1YVw/yJX6Iwt1xa47XQt9k+0LMvNM5qm3T9cDJdw6uuWARAFJQyWR0
         EDVk7du+Z4HgKfISycCZFBdjss0KK3XjYzSmbHcvOzuv1Aa/gB8EOz8AV6ZeCDLmGyW5
         5sH6tVYGbvBaoXttOm555CWFuX6g//6yAoTXvh1g+G7Kab4eBb7aproPk+bYd/zS7HXR
         pzxw==
X-Gm-Message-State: ANhLgQ3LPLxQEwH82cWWef/eiMEjkRXQLRkuw6zTqKmtb+1HY4slbCY7
        EOtPMIHX6qC77JclDblojCWpjg==
X-Google-Smtp-Source: ADFU+vvQkJHNXbvVdLtnlJMGZHp70Sk2ysRUXTAeHVBKUuaYuYs7P0Nymi41g21wcvfTtdp5N+dboA==
X-Received: by 2002:ac8:184f:: with SMTP id n15mr190677qtk.371.1584466335681;
        Tue, 17 Mar 2020 10:32:15 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id z1sm2584388qtc.51.2020.03.17.10.32.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 17 Mar 2020 10:32:14 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jEG4c-0006CT-8g; Tue, 17 Mar 2020 14:32:14 -0300
Date:   Tue, 17 Mar 2020 14:32:14 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Ralph Campbell <rcampbell@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, kvm-ppc@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] mm: simplify device private page handling in
 hmm_range_fault
Message-ID: <20200317173214.GT20941@ziepe.ca>
References: <20200316193216.920734-1-hch@lst.de>
 <20200316193216.920734-4-hch@lst.de>
 <7256f88d-809e-4aba-3c46-a223bd8cc521@nvidia.com>
 <20200317121536.GQ20941@ziepe.ca>
 <20200317122445.GA11662@lst.de>
 <20200317122813.GA11866@lst.de>
 <20200317124755.GR20941@ziepe.ca>
 <20200317125955.GA12847@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317125955.GA12847@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 17, 2020 at 01:59:55PM +0100, Christoph Hellwig wrote:
> On Tue, Mar 17, 2020 at 09:47:55AM -0300, Jason Gunthorpe wrote:
> > I've been using v7 of Ralph's tester and it is working well - it has
> > DEVICE_PRIVATE support so I think it can test this flow too. Ralph are
> > you able?
> > 
> > This hunk seems trivial enough to me, can we include it now?
> 
> I can send a separate patch for it once the tester covers it.  I don't
> want to add it to the original patch as it is a significant behavior
> change compared to the existing code.

Okay. I'm happy enough for now that amdgpu will get ERROR on
device_private pages. That is a bug fix in of itself.

Jason
