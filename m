Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4747210A940
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 Nov 2019 05:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfK0EAC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 26 Nov 2019 23:00:02 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45018 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbfK0EAC (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 26 Nov 2019 23:00:02 -0500
Received: by mail-pf1-f193.google.com with SMTP id d199so5638189pfd.11
        for <kvm-ppc@vger.kernel.org>; Tue, 26 Nov 2019 20:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=tPzDWP52pMIW0y9GhlwYX53ztb59aZtQFUquyPdBxfQ=;
        b=UA8cQT4sPPzDAk/yTmdElxaXyjFhnyRrpJcZyeNQEMYcKEux7hM1c6kIoFx1I+yZuQ
         wN9kOvOYAVbLuLJgFdUCiA93CNslXHAYkYU3YhHVBar9wTtwlvW4T1is/gL3v2G+qHAe
         2dHdKnVESFH0+imrOfB2xhv6HRYVpoAapdyhCtotxrTInZD0aaLaqfC8ShIPlUDnPnm6
         hMaAUCobOX6QapYVbPDqtF11Z+brEgBxb6KoiNMrE8ELQja4mIfRiRA5m/wmUn6OuN/V
         FmfyMc+d8Ryyd2YkcVQKs4IdCof104zjZEnhS5YbupC5ASsJtZhUFtQj7Io1kcfMVCTJ
         ic+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=tPzDWP52pMIW0y9GhlwYX53ztb59aZtQFUquyPdBxfQ=;
        b=h//ogWs3r9nA9Fn4sH5yroIEbHfbqWOFCq4kKcgduywkaycWPCk5Atb2CwCIfPoc1K
         pIxhiFc5kAn9XFQt8BkWHQZCsg1x/pGAJBNmXep0SWE2M1ijI4mBgg16Nxgrm5/zQVW5
         kP/RtngEA6nCjXmIPMaWZ6jiwQZYdEAWfzucJSQFIansdahl+q8BE8eWR7KtJh0ac6kS
         93hoi2LFm0xClpmOY+opnAZyqvxU2HPG2OSJDjN5Rk+PQpkXwfm3m8MfnqEC+cO7yDTB
         bxajibGX7FGJPYNVb8jF9jHzwkxFPaa5LK0ZQX1FXo0XKnlIfolFx69K/imUi4SxOKSl
         glLA==
X-Gm-Message-State: APjAAAW48ZOb1UeqWmnvnl4jX/lM9q6hxma1tQJ/eZPD/XgGSrf4pjJW
        kZypv23bo6ibedIeUbbK9YLZjapVLYI=
X-Google-Smtp-Source: APXvYqxNhIt4XZITVq9WPYXV1dSIMA6E+ZrqrkYj3fsimovUhhlRrArdOtsqQOIYfGGnTZLFn9wNGw==
X-Received: by 2002:a63:6d4f:: with SMTP id i76mr146712pgc.301.1574827200514;
        Tue, 26 Nov 2019 20:00:00 -0800 (PST)
Received: from [100.112.92.218] ([104.133.9.106])
        by smtp.gmail.com with ESMTPSA id m5sm4479407pjl.30.2019.11.26.19.59.58
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 26 Nov 2019 19:59:59 -0800 (PST)
Date:   Tue, 26 Nov 2019 19:59:49 -0800 (PST)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     Bharata B Rao <bharata@linux.ibm.com>
cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sukadev@linux.vnet.ibm.com, hch@lst.de,
        Paul Mackerras <paulus@ozlabs.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v11 1/7] mm: ksm: Export ksm_madvise()
In-Reply-To: <20191125030631.7716-2-bharata@linux.ibm.com>
Message-ID: <alpine.LSU.2.11.1911261834380.1600@eggly.anvils>
References: <20191125030631.7716-1-bharata@linux.ibm.com> <20191125030631.7716-2-bharata@linux.ibm.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, 25 Nov 2019, Bharata B Rao wrote:

> On PEF-enabled POWER platforms that support running of secure guests,
> secure pages of the guest are represented by device private pages
> in the host. Such pages needn't participate in KSM merging. This is
> achieved by using ksm_madvise() call which need to be exported
> since KVM PPC can be a kernel module.
> 
> Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
> Acked-by: Paul Mackerras <paulus@ozlabs.org>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Hugh Dickins <hughd@google.com>

I can say
Acked-by: Hugh Dickins <hughd@google.com>
to this one.

But not to your 2/7 which actually makes use of it: because sadly it
needs down_write(&kvm->mm->mmap_sem) for the case when it switches off
VM_MERGEABLE in vma->vm_flags.  That's frustrating, since I think it's
the only operation for which down_read() is not good enough.

I have no idea how contended that mmap_sem is likely to be, nor how
many to-be-secured pages that vma is likely to contain: you might find
it okay simply to go with it down_write throughout, or you might want
to start out with it down_read, and only restart with down_write (then
perhaps downgrade_write later) when you see VM_MERGEABLE is set.

The crash you got (thanks for the link): that will be because your
migrate_vma_pages() had already been applied to a page that was
already being shared via KSM.

But if these secure pages are expected to be few and far between,
maybe you'd prefer to keep VM_MERGEABLE, and add per-page checks
of some kind into mm/ksm.c, to skip over these surprising hybrids.

Hugh

> ---
>  mm/ksm.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index dbee2eb4dd05..e45b02ad3f0b 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -2478,6 +2478,7 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(ksm_madvise);
>  
>  int __ksm_enter(struct mm_struct *mm)
>  {
> -- 
> 2.21.0
