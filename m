Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFDD864778
	for <lists+kvm-ppc@lfdr.de>; Wed, 10 Jul 2019 15:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbfGJNrh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 10 Jul 2019 09:47:37 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44885 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbfGJNrh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 10 Jul 2019 09:47:37 -0400
Received: by mail-qt1-f196.google.com with SMTP id 44so2417067qtg.11
        for <kvm-ppc@vger.kernel.org>; Wed, 10 Jul 2019 06:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7U6Nt7OEfvKxcNWy+tvVorAtvgeJ3jhS1Gu2nX61T9o=;
        b=VrcajUFHnL11D6RL+P9on2xGE4JRl04eDGqwQa5qHE8yXtYmOepQdn7ImaobBudj7h
         BbrC4OOPHj5Qvw25DS/glET43DNZGXzIRQGBpRQUKbEsXspnhXlZ3KGsM7Pp4aC7bYcy
         xDwg42eG7T/GACYBefhfJvB8Acg/r/4AciCDj9FzSGNWN+gTJPVnDtkmPiLQt7KFx4lc
         xLv01uYuGtD+S7G0ERpM+v/8K6p9F4eb7g1kmAVVHkUxI/XZN8xEVEnCzMR1FKB74vmG
         gZV7WpiK/hm4dD2vXlBdZlSLCSy2C12W+pykqbzTB6uX0Io3B56dcV3GvUGjIDbdWAxJ
         3QcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7U6Nt7OEfvKxcNWy+tvVorAtvgeJ3jhS1Gu2nX61T9o=;
        b=D+xNJcY9y5qywq/17gdKcDBtm7VkqhuR008qG5W62k/huK5080asqoso0wY+0qu3VM
         fO1R1cl9Poe+Ic0g9Xsnkk+LFwGYknofQt8E8jzckxzigLPkdLh9aipuHK1IcDQHx7nw
         uBXuV5cJeTP42cb6is6P/3/Dot4YFwI8JjEjRrTykXlrT7oW7VNo01cTIQl0rdToDwtE
         uClilq6h+JcNr9ZaRZ1QDTT5T1Sj+yS5QMiNpnkV9jez/Kqm/D0hfSHNts4L4+Ru3gU0
         mW//zZQWyl7dAuJkiK3CNYKNibPorykyts95Qf4gM8x/xZ8ndvxwbpD/0jqwF6Nj3k1P
         5bkA==
X-Gm-Message-State: APjAAAVinaJer58PTMCGSDidek1F3394JgMMUlHuRAMx2h9iLMFNL4bW
        d8PfDWILq6WQU8TW/CUw6xJopw==
X-Google-Smtp-Source: APXvYqygCMHzTUHQC/+aI1gVFaxUXYVDQQtJfFKzO9aN4lth9Iok18xe2Gb/ZZLBzuS0ZLO+5Jk8kQ==
X-Received: by 2002:a0c:8b49:: with SMTP id d9mr24649143qvc.178.1562766456016;
        Wed, 10 Jul 2019 06:47:36 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id o18sm1314520qtb.53.2019.07.10.06.47.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Jul 2019 06:47:35 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hlCwY-00013E-UQ; Wed, 10 Jul 2019 10:47:34 -0300
Date:   Wed, 10 Jul 2019 10:47:34 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     janani <janani@linux.ibm.com>
Cc:     Bharata B Rao <bharata@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linuxram@us.ibm.com,
        cclaudio@linux.ibm.com, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, jglisse@redhat.com,
        aneesh.kumar@linux.vnet.ibm.com, paulus@au1.ibm.com,
        sukadev@linux.vnet.ibm.com,
        Linuxppc-dev 
        <linuxppc-dev-bounces+janani=linux.ibm.com@lists.ozlabs.org>
Subject: Re: [PATCH v5 1/7] kvmppc: HMM backend driver to manage pages of
 secure guest
Message-ID: <20190710134734.GB2873@ziepe.ca>
References: <20190709102545.9187-1-bharata@linux.ibm.com>
 <20190709102545.9187-2-bharata@linux.ibm.com>
 <29e536f225036d2a93e653c56a961fcb@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29e536f225036d2a93e653c56a961fcb@linux.vnet.ibm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Jul 09, 2019 at 01:55:28PM -0500, janani wrote:

> > +int kvmppc_hmm_init(void)
> > +{
> > +	int ret = 0;
> > +	unsigned long size;
> > +
> > +	size = kvmppc_get_secmem_size();
> > +	if (!size) {
> > +		ret = -ENODEV;
> > +		goto out;
> > +	}
> > +
> > +	kvmppc_hmm.device = hmm_device_new(NULL);
> > +	if (IS_ERR(kvmppc_hmm.device)) {
> > +		ret = PTR_ERR(kvmppc_hmm.device);
> > +		goto out;
> > +	}
> > +
> > +	kvmppc_hmm.devmem = hmm_devmem_add(&kvmppc_hmm_devmem_ops,
> > +					   &kvmppc_hmm.device->device, size);
> > +	if (IS_ERR(kvmppc_hmm.devmem)) {
> > +		ret = PTR_ERR(kvmppc_hmm.devmem);
> > +		goto out_device;
> > +	}

This 'hmm_device' API family was recently deleted from hmm:

commit 07ec38917e68f0114b9c8aeeb1c584b5e73e4dd6
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed Jun 26 14:27:01 2019 +0200

    mm: remove the struct hmm_device infrastructure
    
    This code is a trivial wrapper around device model helpers, which
    should have been integrated into the driver device model usage from
    the start.  Assuming it actually had users, which it never had since
    the code was added more than 1 1/2 years ago.

This patch should use the driver core directly instead.

Regards,
Jason
