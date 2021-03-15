Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20C633ACD2
	for <lists+kvm-ppc@lfdr.de>; Mon, 15 Mar 2021 08:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhCOHxN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 15 Mar 2021 03:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhCOHxL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 15 Mar 2021 03:53:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04386C061574;
        Mon, 15 Mar 2021 00:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FCQj5B5Zp1rCBgedoXr3WWrEwlMWhZUzdqOcxosJGQw=; b=wRkw1cfr0IC8CR6t82z+HYxHFv
        VwF/tmGGdg4KPiwHX84XlVhB70vI4qKVPJb4zq2X0u72shDpS3zQnjEPkkVBEQyLoYdu7hZMdOQXM
        UIdFcYK8CUjNIvi3bzvpYQfQefNFXErUWa8P0ORjcvxmtaUgR3L2QHe8JipBS3IXKTRAUYM8zt3CL
        PlSQnfmpbv68kjqm6E5FTHerLPsTO1lDnQtEl+KweBJyzyuRjrj/f7i47X3awojHqCazrDuXVvNnJ
        B+BCGRiX8eIBhxPucslU4zDrXnmg9fLIfS7pNLD8peWWGhHmwlVcDfaGAn229P3hdRo0y0OsXuxsA
        QWr2l9bw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lLi0P-00HOOO-B9; Mon, 15 Mar 2021 07:51:24 +0000
Date:   Mon, 15 Mar 2021 07:51:13 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     linux-mm@kvack.org, nouveau@lists.freedesktop.org,
        bskeggs@redhat.com, akpm@linux-foundation.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, dri-devel@lists.freedesktop.org,
        jhubbard@nvidia.com, rcampbell@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, hch@infradead.org, daniel@ffwll.ch,
        willy@infradead.org
Subject: Re: [PATCH v6 8/8] nouveau/svm: Implement atomic SVM access
Message-ID: <20210315075113.GD4136862@infradead.org>
References: <20210312083851.15981-1-apopple@nvidia.com>
 <20210312083851.15981-9-apopple@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312083851.15981-9-apopple@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

> -	/*XXX: atomic? */
> -	return (fa->access == 0 || fa->access == 3) -
> -	       (fb->access == 0 || fb->access == 3);
> +	/* Atomic access (2) has highest priority */
> +	return (-1*(fa->access == 2) + (fa->access == 0 || fa->access == 3)) -
> +	       (-1*(fb->access == 2) + (fb->access == 0 || fb->access == 3));

This looks really unreabable.  If the magic values 0, 2 and 3 had names
it might become a little more understadable, then factor the duplicated
calculation of the priority value into a helper and we'll have code that
mere humans can understand..

> +		mutex_lock(&svmm->mutex);
> +		if (mmu_interval_read_retry(&notifier->notifier,
> +					    notifier_seq)) {
> +			mutex_unlock(&svmm->mutex);
> +			continue;
> +		}
> +		break;
> +	}

This looks good, why not:

		mutex_lock(&svmm->mutex);
		if (!mmu_interval_read_retry(&notifier->notifier,
					     notifier_seq))
			break;
		mutex_unlock(&svmm->mutex);
	}
