Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8F918739B
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Mar 2020 20:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732413AbgCPTtW (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 16 Mar 2020 15:49:22 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39654 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732448AbgCPTtW (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 16 Mar 2020 15:49:22 -0400
Received: by mail-qt1-f195.google.com with SMTP id f17so14072784qtq.6
        for <kvm-ppc@vger.kernel.org>; Mon, 16 Mar 2020 12:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=o7JqLPPCRpGtDbfSiR++DTgayckzFt0qLULy0U0IXIw=;
        b=GGJyf40oBvUn3UsnYOHO6ftCMOlhlUE53mKdQJAM3RZ49VrR7NfNu6vFSbIJg0Vrp+
         nKaEHE/9u/3vvjCCe8WwHh8SthbR1oMP/lq3mlydxzkJGNn/tuTNACX8TZxQceM/9mon
         YIOCmCOQYTnLI6cUij9NQ1KEjPZ6YzkCBGaFSk2yslH5PGKF31RBGv+LalaZ8j2uIFLh
         bC7emlaCft8W3JdiciO0idkiwtVoNDBdFG9zx0aEVhvj80fXi5TE1dCzgDd5RWL/YOhG
         YYChBQ/vDVC92ft0WvWlgaDNuQmhJ1/CKwgNKV4aCfjmwGoqd/IKybrQhzqaZzus/5a5
         BRgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=o7JqLPPCRpGtDbfSiR++DTgayckzFt0qLULy0U0IXIw=;
        b=lis103hG1tLWq6BGw9LbzdTsjraBxPS3uJWkJLIx9zfs5Fn1VFQL3QfR/gSOWbPHOh
         Rj28b0QF1NPbWd/ykM3pNrjXx5Bny51no+yPLjm64ZohjjZ16oh3P0+VN3HMbMcywKRO
         M45N563m/bnXNaCw3ul9k6rHZEB6fY2MU6GjWtK2zPZtQehOAX2CMVfyGPpcQO6ZDu9f
         7EgiJkz81bXdxr+TypLHdVjfO0ARN5u/KnOpUW0egDBZzSbb6u11V/AcoT6fZy3M5ohA
         ok2RUPQOBq2gtXcIurt+GgHc5xU4Gqu5UcWQ8au295xGxFAzsxIcYQO7L8NeQ/rUwkku
         4RFA==
X-Gm-Message-State: ANhLgQ0TTgxmDIEqgrYuMGyd3+R19W52ax9xQtCuPOscTe5wPRnqxYAr
        85pYxVUZ1K+WvF7bT49pXAs2Kg==
X-Google-Smtp-Source: ADFU+vtYiqHgSFb/FCS3+UBgOOiW2jlaSoZd/0nI0+DDGOjwoiONzmkAwxqo+x9vqhMLJgCeBnROrw==
X-Received: by 2002:ac8:5209:: with SMTP id r9mr1812897qtn.61.1584388161299;
        Mon, 16 Mar 2020 12:49:21 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id m67sm406383qke.101.2020.03.16.12.49.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 16 Mar 2020 12:49:20 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jDvjk-00071k-6b; Mon, 16 Mar 2020 16:49:20 -0300
Date:   Mon, 16 Mar 2020 16:49:20 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, kvm-ppc@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] mm: check the device private page owner in
 hmm_range_fault
Message-ID: <20200316194920.GA20010@ziepe.ca>
References: <20200316193216.920734-1-hch@lst.de>
 <20200316193216.920734-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316193216.920734-5-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Mar 16, 2020 at 08:32:16PM +0100, Christoph Hellwig wrote:
> Hmm range fault will succeed for any kind of device private memory,
> even if it doesn't belong to the calling entity.  While nouveau
> has some crude checks for that, they are broken because they assume
> nouveau is the only user of device private memory.  Fix this by
> passing in an expected pgmap owner in the hmm_range_fault structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Fixes: 4ef589dc9b10 ("mm/hmm/devmem: device memory hotplug using ZONE_DEVICE")
> ---
>  drivers/gpu/drm/nouveau/nouveau_dmem.c | 12 ------------
>  include/linux/hmm.h                    |  2 ++
>  mm/hmm.c                               | 10 +++++++++-
>  3 files changed, 11 insertions(+), 13 deletions(-)

Nice

Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>

Jason
