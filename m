Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 935701873BD
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Mar 2020 20:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732447AbgCPT70 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 16 Mar 2020 15:59:26 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38957 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732436AbgCPT70 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 16 Mar 2020 15:59:26 -0400
Received: by mail-qt1-f196.google.com with SMTP id f17so14103052qtq.6
        for <kvm-ppc@vger.kernel.org>; Mon, 16 Mar 2020 12:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EAEH/7t5ubtIMhw4ZTeVgjQSlcx5QOWTPoLF4PtWhvw=;
        b=RmOqUe+R4l5H6YpqEib1W4LfA1h1/OZym/f9ehFr0qPoTlxgBeLu6AJhJEmNnQN1Dj
         VE0p9XlPU1CSB+PhFNJXeVAL1LDo4nVZlApvnbIOxbw+r/nV9Gg6fFNKzOdwP2Rv+Tcn
         jO4CyQOKGxDjCENXESz3JqP8SloGlWtsxFs4A+S9T2ZlNyxyjePg81CckrADJ18xntlN
         aHclWcT2nw64C3P/y74znOjO+t0uMLoSAJuwol49hiClFZErw7yVlf364WCNiDmO2nJm
         W+hBIi0t5YKyy6lPGMloSf+ZExCMZJ+fh4fYcxzQVhaJT+DK5PvzuCPkceNPvN3cAj8p
         AGog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EAEH/7t5ubtIMhw4ZTeVgjQSlcx5QOWTPoLF4PtWhvw=;
        b=JFUrn8bvdSGm9P7bvXa4vOTGampoYlhpLx6gu1cMPUOVxWQ87fHWXbQsVZKY9bWn+i
         vjHzxvdB/6M8uSDsmQULIZsvNnkb4fWCoytruGkGJhZsVfmb9FNaRVHNwNNg3i6UkpDa
         WxxJ1iq+bGzYxXyfvyKQTtt49Rnh43vJB8VqwlM6vWIivagqlvuZuHmW8oKkr9fIqCDI
         Jps/6zB3hIwvdbY0DFQ8cJTdlArEmuQVF/XJIqQf/pQF1xMJtpNUrcjY0XNQNpHSbvHl
         Cts2STdn+E6GyyJ6h5uaopi9CZNZJWpwKJTj8BuY/2UZUZSPIbq0l17AbVF5w2qMPQuB
         Le4Q==
X-Gm-Message-State: ANhLgQ1rLJa7AcbvzEUCFn0N7g7eeAZGOtv4tOa6ADoZ2YE4T+yO51C+
        lhG8zUt4WB6PMm2BSZOqaaL6EA==
X-Google-Smtp-Source: ADFU+vtbRUKVYcUI2Gq+ZWCB4v8nheFcrqCqLhbHdThlbs4ZekZNUobGzi4WVSGLSw/oM8Fkr1QlJA==
X-Received: by 2002:ac8:7396:: with SMTP id t22mr1961185qtp.182.1584388764690;
        Mon, 16 Mar 2020 12:59:24 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id x22sm488565qki.54.2020.03.16.12.59.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 16 Mar 2020 12:59:24 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jDvtT-00078y-K3; Mon, 16 Mar 2020 16:59:23 -0300
Date:   Mon, 16 Mar 2020 16:59:23 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, kvm-ppc@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] mm: simplify device private page handling in
 hmm_range_fault
Message-ID: <20200316195923.GA26988@ziepe.ca>
References: <20200316193216.920734-1-hch@lst.de>
 <20200316193216.920734-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316193216.920734-4-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Mar 16, 2020 at 08:32:15PM +0100, Christoph Hellwig wrote:
> diff --git a/mm/hmm.c b/mm/hmm.c
> index 180e398170b0..cfad65f6a67b 100644
> +++ b/mm/hmm.c
> @@ -118,15 +118,6 @@ static inline void hmm_pte_need_fault(const struct hmm_vma_walk *hmm_vma_walk,
>  	/* We aren't ask to do anything ... */
>  	if (!(pfns & range->flags[HMM_PFN_VALID]))
>  		return;
> -	/* If this is device memory then only fault if explicitly requested */
> -	if ((cpu_flags & range->flags[HMM_PFN_DEVICE_PRIVATE])) {
> -		/* Do we fault on device memory ? */
> -		if (pfns & range->flags[HMM_PFN_DEVICE_PRIVATE]) {
> -			*write_fault = pfns & range->flags[HMM_PFN_WRITE];
> -			*fault = true;
> -		}
> -		return;
> -	}

Yes, this is an elegant solution to the input flags.

However, between patch 3 and 4 doesn't this break amd gpu as it will
return device_private pages now if not requested? Squash the two?

Jason
