Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 933D818B295
	for <lists+kvm-ppc@lfdr.de>; Thu, 19 Mar 2020 12:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgCSLuc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 19 Mar 2020 07:50:32 -0400
Received: from mail-qt1-f177.google.com ([209.85.160.177]:42710 "EHLO
        mail-qt1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbgCSLuc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 19 Mar 2020 07:50:32 -0400
Received: by mail-qt1-f177.google.com with SMTP id g16so1447024qtp.9
        for <kvm-ppc@vger.kernel.org>; Thu, 19 Mar 2020 04:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lBTUj1y9VtUDCn4ytJFEQ/eoQI6G7k2EQxvY7AJpV3c=;
        b=Q9ERC6iPr6C3r4Aftx8b5gwyrS/P6NkAng74KreczcNsHr53jWHlVKuPvCBBh0StdU
         b7wzRK/4QaptzavqQqjoxQtuj+QaqaBcHLAt+n2RM2aODrw/YIvYJOcY6oY/jhXWMdNl
         gFsDyu8l5L6Q4p5/Vec/nQL4ZF96TI6lmJ+GksJOA5nnA/U56BWjdrmmQuHmwq16PEgF
         vEDyKh6pD2UZZlm0QaUjZJg9ezYYrp/3bLf3kWlZYm9kIylqHOwtEoZBn6QJwP79CInq
         PaTsPCn3AYjQRE8u84qlU4iAzPC4kAqGszh17G2RZLFuZX+xqHCLjAuidtRaW2LMrHIM
         4mJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lBTUj1y9VtUDCn4ytJFEQ/eoQI6G7k2EQxvY7AJpV3c=;
        b=LgGUGJnMBa+B50o6AFHoaMB7bwJabq2gLXdafv7tX8f7GrdchcNStjYNb/oTxzyx6+
         B6WwXSpVjsXAiJLYEsd5lVGPrUFJCxPXzHHmqbKJwk5Y6E+gKsovdJjwAmbg6SrJsnOT
         7p16lC3uYhRuzCMvA6iGt5hyx0vqTR5eGS9ouDsyFneE7ab1jWPdtjhc//MGIB4ue12Z
         n3On1S2u7+70itr7Ja2AD6HF955lulMGtaZGNkWrhEPzCFRF6m3QHc/X6S6Maao5yyj7
         HHkIY+05ee7cmQ3DigiPPzozm/o3qYbXIt/rDyEsnnwylxGFF52TBBxLDPJFF1+tgT7c
         Ogdw==
X-Gm-Message-State: ANhLgQ3EuKhvRcM4ZyXpgzw+nkI27sIYtfweXwq79mVwaXh3H7ZjAsC9
        Lded4q4298NvHSbxabKw/dmq/w==
X-Google-Smtp-Source: ADFU+vsIVebb1InTyDcl4fZPuH+UAvQ5tH6FZmi6I4UE9Qq4JBH+2FeGy/XT9qJsD57BNhHjEf5qDA==
X-Received: by 2002:ac8:24a7:: with SMTP id s36mr2441422qts.357.1584618629621;
        Thu, 19 Mar 2020 04:50:29 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id h138sm1339362qke.86.2020.03.19.04.50.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 19 Mar 2020 04:50:28 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jEtgx-0004ip-P2; Thu, 19 Mar 2020 08:50:27 -0300
Date:   Thu, 19 Mar 2020 08:50:27 -0300
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
Message-ID: <20200319115027.GI20941@ziepe.ca>
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

Now that I understand that amdgpu doesn't set the 'do not return
device_private pages' flag, I think the split is fine, I'll grab it as
is then today

Thanks,
Jason
