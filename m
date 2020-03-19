Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D092518BFA5
	for <lists+kvm-ppc@lfdr.de>; Thu, 19 Mar 2020 19:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgCSSuT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 19 Mar 2020 14:50:19 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34129 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727002AbgCSSuS (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 19 Mar 2020 14:50:18 -0400
Received: by mail-qt1-f196.google.com with SMTP id 10so2810686qtp.1
        for <kvm-ppc@vger.kernel.org>; Thu, 19 Mar 2020 11:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+iQmmyqtxCtarJ4YRBKb0yWGqnthI8hUUC43IFJE2lc=;
        b=O+T+k7QcGsKIEHBjgipyL31XPaNddanzbawgGU863gdvDPNIX7LYi3WVs/mOCkQatM
         kp3xPR0l9A+vuyX750Q+3/7jJVu4icOVMoEC/ohdQ5GVvA3ARolXe4ZZVnWtakCYOGal
         boy4qnC1A6on3cpFaP6DgucabbLC6sHg+E7Qo7m9ag0aas++wv/SLWln/6E5qDazux78
         cdzi7JujpLBWCBJqNIB5d7eOJ93n7akLN+Ctr6uYuANCJPwzugp1TU5/0Zr3jU0FqhYQ
         5GF51y82KW0QITwSWN2Y1KbEajR7yA6aP5DQTQFmk2rLd5pBravF6IH6lq8HScNN4zv7
         xo1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+iQmmyqtxCtarJ4YRBKb0yWGqnthI8hUUC43IFJE2lc=;
        b=tMWRDx+zlOij6cj2Nof11zUyfFTUaMxNmbuuPR36m/JaThGbMKJYIGpBn6IAJ6Cwhl
         hWEiHksT1SaWmz5gdUeGgxgyHAC5s1atv2+fYs5+IIjfTNaw2xerb178YjJKwAjZ4UpA
         ucxNMOqWuF/vNh8VcGWj4FjNaSRYuUbdB60Ty4FI87R8q6nEf4h0H4kxRi6wcRNIjzne
         jK8ZznORgUuT1QtzBB8RpDoIRQ4iiYeHMFVqpIVjEeSs05TJKUbiPikQHvtscjgqe06M
         NA6Ubql25tOELNMz9Zmqc8gjIFG6DLEMvv+IVgzLae4WCtCJ/PyOxShqsXd1Thlu6YF0
         9z6g==
X-Gm-Message-State: ANhLgQ0KaiTJnuRnGJcZLr/WmcD7JOg88/i5RMt3w0vUVQVM7hw3FI6m
        AePh4CMAdKegOh7kti/euIPkhQ==
X-Google-Smtp-Source: ADFU+vvq32in5Qjs8YAHdFEpYAPgT41J1WfLa2uHLd4XxlB1EmISPkcd3J2y54DRcA2TER5nFwTi4A==
X-Received: by 2002:ac8:4548:: with SMTP id z8mr4613857qtn.188.1584643817615;
        Thu, 19 Mar 2020 11:50:17 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id 82sm2177475qkd.62.2020.03.19.11.50.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 19 Mar 2020 11:50:16 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jF0FD-0004NT-Vw; Thu, 19 Mar 2020 15:50:15 -0300
Date:   Thu, 19 Mar 2020 15:50:15 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, kvm-ppc@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: ensure device private pages have an owner v2
Message-ID: <20200319185015.GM20941@ziepe.ca>
References: <20200316193216.920734-1-hch@lst.de>
 <20200319002849.GG20941@ziepe.ca>
 <20200319071633.GA32522@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319071633.GA32522@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Mar 19, 2020 at 08:16:33AM +0100, Christoph Hellwig wrote:
> On Wed, Mar 18, 2020 at 09:28:49PM -0300, Jason Gunthorpe wrote:
> > > Changes since v1:
> > >  - split out the pgmap->owner addition into a separate patch
> > >  - check pgmap->owner is set for device private mappings
> > >  - rename the dev_private_owner field in struct migrate_vma to src_owner
> > >  - refuse to migrate private pages if src_owner is not set
> > >  - keep the non-fault device private handling in hmm_range_fault
> > 
> > I'm happy enough to take this, did you have plans for a v3?
> 
> I think the only open question is if merging 3 and 4 might make sense.
> It's up to you if you want it resent that way or not.

Okay, I kept it as is and elaborated the commit messages a bit based
on the discussion

It doesn't seem like the changes outside hmm are significant enough to
need more acks

Thanks,
Jason
