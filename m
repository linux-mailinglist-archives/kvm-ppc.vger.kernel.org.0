Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 487A5188378
	for <lists+kvm-ppc@lfdr.de>; Tue, 17 Mar 2020 13:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgCQMPk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 17 Mar 2020 08:15:40 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39700 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgCQMPk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 17 Mar 2020 08:15:40 -0400
Received: by mail-qt1-f193.google.com with SMTP id f17so15831021qtq.6
        for <kvm-ppc@vger.kernel.org>; Tue, 17 Mar 2020 05:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=embLdYCC+n7Oc9s6Q8ZHyjDJLIa4kBbr1h9BCOMYbH4=;
        b=SQzUEb66s7EkVHhGjTvINACKhElAAylB3fP+JIE5uJtINxUSWP+viORRExV6sx6htD
         HpVjFFlfhYosV5Dtv6arQkz6yiV2Baf2i4b1LfAOirqSi7orDhzKcNalylzPx3FE1iin
         oP+wLU4hopi4dKyJTpvXWz51qQrzPAGcS4kKz84+9KAoAC2yW49o3KG6agUJaN37k6yK
         HuepGzVyNECsPyMpp1CtLxq1h9Taueop5kQtr0Zv8iKdXRs41vSS5Kb4H/Sh9sxSVbBi
         Mn9h5qwb5Z+4eSnt+xfXYW9HjJYHq+hghoj++xGbpVpzLV1xGx/h/5X4aTndQ1jk78Xd
         Y1OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=embLdYCC+n7Oc9s6Q8ZHyjDJLIa4kBbr1h9BCOMYbH4=;
        b=qyY3nWTwNxD6InYHIFuDqjuadULxpVeAD4HNM1M0Fauz3FrqSnc1uy2dpXeIFI7lv0
         KB9mBmKXVMxWBAYz1QFfjuVA/Du99WUesVI1s8vfeqR7UACqPyJRzbtaZCdDZ0OYbkpO
         pTTOHktoCrwOIoFjyxKhJTWd7hycPPPbPp8iXmLrGiXFajy9cgfA+zjd9FXYC6dQtITx
         7IxEfnFGeMGryx+TPKWO7LX4CK1K9XDhJb9Ir4D68ItG2ylHkoerWdKuhSJ97Kba5yac
         0S9+53x7IKk6rP6I7T/0WLurb8FbiJ7zrxm0HEOxDKNukfwDVGH+dAHt/Yfvyv0sYzBE
         +mLg==
X-Gm-Message-State: ANhLgQ1YSCkn6qSLq3Sjbcrj0CSPzFWwA1jDglF+sJLSfn0Q+3fo8XkW
        NmKhexgt8CUWUihZE3l0j1lSqQ==
X-Google-Smtp-Source: ADFU+vsrbs1FMDMvrBo9cu5QRVB0IZzDlkTw1XDG3EBbGMsL3EdtYUQXQDIyFHCwplMScIrZT+xPIg==
X-Received: by 2002:aed:2ba2:: with SMTP id e31mr4988796qtd.286.1584447338651;
        Tue, 17 Mar 2020 05:15:38 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id k13sm2042705qtm.11.2020.03.17.05.15.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 17 Mar 2020 05:15:38 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jEB8C-00012L-NV; Tue, 17 Mar 2020 09:15:36 -0300
Date:   Tue, 17 Mar 2020 09:15:36 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, kvm-ppc@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] mm: simplify device private page handling in
 hmm_range_fault
Message-ID: <20200317121536.GQ20941@ziepe.ca>
References: <20200316193216.920734-1-hch@lst.de>
 <20200316193216.920734-4-hch@lst.de>
 <7256f88d-809e-4aba-3c46-a223bd8cc521@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7256f88d-809e-4aba-3c46-a223bd8cc521@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Mar 16, 2020 at 03:49:51PM -0700, Ralph Campbell wrote:
> 
> On 3/16/20 12:32 PM, Christoph Hellwig wrote:
> > Remove the code to fault device private pages back into system memory
> > that has never been used by any driver.  Also replace the usage of the
> > HMM_PFN_DEVICE_PRIVATE flag in the pfns array with a simple
> > is_device_private_page check in nouveau.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Getting rid of HMM_PFN_DEVICE_PRIVATE seems reasonable to me since a driver can
> look at the struct page but what if a driver needs to fault in a page from
> another device's private memory? Should it call handle_mm_fault()?

Isn't that what this series basically does?

The dev_private_owner is set to the type of pgmap the device knows how
to handle, and everything else is automatically faulted for the
device.

If the device does not know how to handle device_private then it sets
dev_private_owner to NULL and it never gets device_private pfns.

Since the device_private pfn cannot be dma mapped, drivers must have
explicit support for them.

Jason
