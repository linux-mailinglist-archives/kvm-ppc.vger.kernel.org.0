Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 126DD647F3
	for <lists+kvm-ppc@lfdr.de>; Wed, 10 Jul 2019 16:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfGJOPu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 10 Jul 2019 10:15:50 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45306 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfGJOPu (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 10 Jul 2019 10:15:50 -0400
Received: by mail-qk1-f194.google.com with SMTP id s22so1956268qkj.12
        for <kvm-ppc@vger.kernel.org>; Wed, 10 Jul 2019 07:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vODFuMSbeG4w9Dj8p2oXEkAy/A03DVwyuAKVY4sFSRA=;
        b=AwdPd/ngT3mJRYvTsNi7+k6Pexs7qADcyr631JXNtQYsxsI+pH7+y4Ce9rum+RXvxW
         m6QBM9fvhZyOBfFcND8pcYtyZWgTB4xQtqhO9xec9FnEJqGhT5MTG3e9VhN/LHD9dgZa
         f6KOC1WXJurqXAAjkgCghV2QgM6A9EVmh5WxWeFLyGZ145JlBsCAs1BNm9jIM7t9z+Hc
         EKiq9t1c2J3X+T5XD78LORMaSqOdjhRrOwldzb/ODveWc7eQ/bjHUQA8gV5DDMl8dAJ8
         rbTcSw4HlbgcmSJKmRzKBIRGpIR9wdnJ3ZyQy1J/UbNA1XsBCR8R5xEtifXe51rYR1ZI
         Q9Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vODFuMSbeG4w9Dj8p2oXEkAy/A03DVwyuAKVY4sFSRA=;
        b=StPDp4uAj5lWsKIKN3BhJmPRQ7wGro9NjqpbAn1GhkExHdam7AI9twxR/iodcMVZTE
         taRzUHWzfJx/OxLyq+2ZIm1iCzoLkQpAffDnOh/Vlg0toig9WXXwo1W3WVFG/XLfT5nT
         JYgSC/p/m5QI5o733nYpIGg8Nwxoe+wxy/VQjcL7cTCldlNZuT98nEdHoiaroHtlYuY0
         LPBxdEXCefeWlU+dm6wEfoZKs7cwQO4Kah1vr67rwVP/fTReuQXorQLaoxdYOyQr4IHO
         MAVlnb8DvzdjE8l6aGmmQ7xfxzBTZu2yyj1/qAXZuWiCdq7pzkFCgbE1SSc6OoLRxBLl
         s51Q==
X-Gm-Message-State: APjAAAWZAlnQfkcgazNLXQH4GtgH6nTrSW5Pe7iY+ma8GKMZ2MVRJgLD
        WM7nAKJ6w1/6AxhzJ8OFT+itPg==
X-Google-Smtp-Source: APXvYqwXdpeAq5FslPtKDZcIHkELBHHKwO4EIuzyaxhuC4csZ6L2yQ89iBXj5IXMg03W1UYI3SVt8w==
X-Received: by 2002:a05:620a:1456:: with SMTP id i22mr23125794qkl.170.1562768149112;
        Wed, 10 Jul 2019 07:15:49 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id i27sm1079838qkk.58.2019.07.10.07.15.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Jul 2019 07:15:48 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hlDNr-0001Pb-Qi; Wed, 10 Jul 2019 11:15:47 -0300
Date:   Wed, 10 Jul 2019 11:15:47 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     janani <janani@linux.ibm.com>
Cc:     Bharata B Rao <bharata@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linuxram@us.ibm.com,
        cclaudio@linux.ibm.com, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, jglisse@redhat.com,
        aneesh.kumar@linux.vnet.ibm.com, paulus@au1.ibm.com,
        sukadev@linux.vnet.ibm.com,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Linuxppc-dev 
        <linuxppc-dev-bounces+janani=linux.ibm.com@lists.ozlabs.org>
Subject: Re: [PATCH v5 7/7] KVM: PPC: Ultravisor: Add PPC_UV config option
Message-ID: <20190710141547.GB4051@ziepe.ca>
References: <20190709102545.9187-1-bharata@linux.ibm.com>
 <20190709102545.9187-8-bharata@linux.ibm.com>
 <6759c8a79b2962d07ed99f2b1cd05637@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6759c8a79b2962d07ed99f2b1cd05637@linux.vnet.ibm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Jul 10, 2019 at 08:24:56AM -0500, janani wrote:
> On 2019-07-09 05:25, Bharata B Rao wrote:
> > From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> > 
> > CONFIG_PPC_UV adds support for ultravisor.
> > 
> > Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> > Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
> > Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> > [ Update config help and commit message ]
> > Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
>  Reviewed-by: Janani Janakiraman <janani@linux.ibm.com>
> >  arch/powerpc/Kconfig | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> > 
> > diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> > index f0e5b38d52e8..20c6c213d2be 100644
> > +++ b/arch/powerpc/Kconfig
> > @@ -440,6 +440,26 @@ config PPC_TRANSACTIONAL_MEM
> >           Support user-mode Transactional Memory on POWERPC.
> > 
> > +config PPC_UV
> > +	bool "Ultravisor support"
> > +	depends on KVM_BOOK3S_HV_POSSIBLE
> > +	select HMM_MIRROR
> > +	select HMM
> > +	select ZONE_DEVICE

These configs have also been changed lately, I didn't see any calls to
hmm_mirror in this patchset, so most likely the two HMM selects should
be dropped and all you'll need is ZONE_DEVICE..

Jason
