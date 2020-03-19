Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95EBB18A9C2
	for <lists+kvm-ppc@lfdr.de>; Thu, 19 Mar 2020 01:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgCSA2x (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 18 Mar 2020 20:28:53 -0400
Received: from mail-qv1-f66.google.com ([209.85.219.66]:36879 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbgCSA2x (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 18 Mar 2020 20:28:53 -0400
Received: by mail-qv1-f66.google.com with SMTP id n1so124183qvz.4
        for <kvm-ppc@vger.kernel.org>; Wed, 18 Mar 2020 17:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DIzPGl46tibPTC4Nr1Fne3idEkZVxe0vRVzC9BmYyk8=;
        b=a9OAhtzpaqy8M7ZOiBkM5EuSVHd4yNecpRtC8dRP+l2pPqyfnSd8K92zu0TfGABk1Q
         hYEfZ+7acI2k/zKRdQldlZU6QmFtX2HRogB/BKnbdEtsKAhQeU6fd+MnUlz8ghM8TEw4
         4FSfDydFj/Zz5Td34FIN8pCf7ZG9IBYZHl9AGTNXWI1pvNTxE9cBf86JQxD+vBXs5Fu+
         P3YN0S0cijWwxtWJa0nTOxVZ/FIsv/TFStTBQI0wKucqAubr3tyWjsrl2pHJSEDRw/1M
         2hLIJPL3HFVUmwFiwQrI21J4bRRmujEiUZiEYQWN4CJhod6KqfASdjQsItMOv/RwHOO/
         50tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DIzPGl46tibPTC4Nr1Fne3idEkZVxe0vRVzC9BmYyk8=;
        b=B3klcW6eiPtIWCvISZfSPx7BUJRSckpV/+/dUH9KVWI01jmn14nNECW8NERKi1hfOA
         uAjSDQtA/J1Dd+ypYo5JKbXpBb4pssf+CjQAyC+fFusA3JUHV+AMc5xPcFQDhvbt8hhM
         u8ehJr2NYZXywDlBsrbCaTHbOE4YZCRDK/5sVxoABDwqP2NjLr08+l+POLHGOxy5vY/H
         Fs63m06aZpoQNjYEQqYDIoAEgnCtvFfTvjBWvmvmS1w9p4b4X7wp7msB+XD6tGo3xIEm
         o5AUGu/obyBchJYHSkR++2gxVKHnau6g1k1VTxRE0Zf352MfFkoPnktITEgnripJPdpC
         BQTQ==
X-Gm-Message-State: ANhLgQ1wQ4kDne4ZFyaBNkHSvCnCsO+tBYwKQ2uK8dQM/230kg2dhE2z
        6lM7yf1nCsb5qFa7aAEtfU3aJQ==
X-Google-Smtp-Source: ADFU+vvSjLkx34MB68Vj6dW6PS73cWO5A0gn+n/cmS/y+KLQ6+BjGr0q6lYXU7A7Xm/H0ApV84kRRw==
X-Received: by 2002:a0c:e7c3:: with SMTP id c3mr620345qvo.62.1584577730703;
        Wed, 18 Mar 2020 17:28:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id u123sm433965qkf.77.2020.03.18.17.28.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 18 Mar 2020 17:28:50 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jEj3J-000273-Ln; Wed, 18 Mar 2020 21:28:49 -0300
Date:   Wed, 18 Mar 2020 21:28:49 -0300
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
Message-ID: <20200319002849.GG20941@ziepe.ca>
References: <20200316193216.920734-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316193216.920734-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Mar 16, 2020 at 08:32:12PM +0100, Christoph Hellwig wrote:
> When acting on device private mappings a driver needs to know if the
> device (or other entity in case of kvmppc) actually owns this private
> mapping.  This series adds an owner field and converts the migrate_vma
> code over to check it.  I looked into doing the same for
> hmm_range_fault, but as far as I can tell that code has never been
> wired up to actually work for device private memory, so instead of
> trying to fix some unused code the second patch just remove the code.
> We can add it back once we have a working and fully tested code, and
> then should pass the expected owner in the hmm_range structure.
> 
> Changes since v1:
>  - split out the pgmap->owner addition into a separate patch
>  - check pgmap->owner is set for device private mappings
>  - rename the dev_private_owner field in struct migrate_vma to src_owner
>  - refuse to migrate private pages if src_owner is not set
>  - keep the non-fault device private handling in hmm_range_fault

I'm happy enough to take this, did you have plans for a v3?

Thanks,
Jason
