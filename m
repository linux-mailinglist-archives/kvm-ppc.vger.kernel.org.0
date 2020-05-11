Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFC31CE1C9
	for <lists+kvm-ppc@lfdr.de>; Mon, 11 May 2020 19:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731008AbgEKReg (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 11 May 2020 13:34:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42287 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731006AbgEKReg (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 11 May 2020 13:34:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589218474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jCAJG5qvZrEQpE9xVUmgEKkY6ZGLKpgEhGop1JiyIl0=;
        b=hcyCwnUXTdYBNYFLqUg2GihL4D9uas+zLEUKIUGv/xskDRIm/IoyiczJXfYo/BSslHxCuu
        EfRQlwpWh/vC1qOSUP/IUt6SEic3zgNbVCxYSsAwK2CM53VzR2tf5AsKUcJT+I9umDjRrx
        ysh4dq1P/gu2OJsZCJiKLoFZ2Ggr+S4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-TFqY97ymOJOUODj7URoK8Q-1; Mon, 11 May 2020 13:34:32 -0400
X-MC-Unique: TFqY97ymOJOUODj7URoK8Q-1
Received: by mail-wr1-f70.google.com with SMTP id y7so5547556wrd.12
        for <kvm-ppc@vger.kernel.org>; Mon, 11 May 2020 10:34:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jCAJG5qvZrEQpE9xVUmgEKkY6ZGLKpgEhGop1JiyIl0=;
        b=rQrqFlmaKC7J62TnsjCtad1DJrFZUZhRsyIrHlc89uay8CRwqF+DrW9GKg71V1HSvW
         TH1+64X8XMIsjj0kGLqagoyZSaw3xpFdJqa9bHmIDRzUk9WDEOCk+SYkfn+xRcp38qkt
         p2eguhfCHdn+yindYDU/Fjl4dO9rhVNQa8gaJ3RsEzudXSNaNFjFfhuHiLS9tum1Tag4
         +zGncrFd0CJjvchSmRpHKfpXZL7X1jsiI76pBhNVAGoCn1X4Ng1+7XjacdcXbOEknzsy
         Xe2Lp/bUmkJ/2ATIcfm3ptj66UzUcVFa+xiSePcWwCb1GpLKteeMRddnwhEYTCFf4EaT
         XThw==
X-Gm-Message-State: AGi0PuZN+HAtEW2VYaaR7z8jeWDfC2G2PV1ljr98Z0u1x5/KYfXbGQGa
        /blZcMOBVk/iY8vw0Vru4TES5E2K/5SbXsSMWb7LoOU9dy40brLXixV1Ja4fyWPrpcukfSyzZyv
        sy9M+4FaE/mXGkH4krA==
X-Received: by 2002:a5d:49ca:: with SMTP id t10mr12469216wrs.285.1589218471440;
        Mon, 11 May 2020 10:34:31 -0700 (PDT)
X-Google-Smtp-Source: APiQypJNe6I7z0SbQYOHpqyl28aME7TxGvpzSGiIlzFVueJrlC+GRcVDtQgQEgjyS86Oa3oOuu0xgw==
X-Received: by 2002:a5d:49ca:: with SMTP id t10mr12469194wrs.285.1589218471191;
        Mon, 11 May 2020 10:34:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4c95:a679:8cf7:9fb6? ([2001:b07:6468:f312:4c95:a679:8cf7:9fb6])
        by smtp.gmail.com with ESMTPSA id 89sm18102311wrj.37.2020.05.11.10.34.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 10:34:30 -0700 (PDT)
Subject: Re: [PATCH v2 0/5] Statsfs: a new ram-based file sytem for Linux
 kernel statistics
To:     Jonathan Adams <jwadams@google.com>
Cc:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Emanuele Giuseppe Esposito <e.emanuelegiuseppe@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20200504110344.17560-1-eesposit@redhat.com>
 <CA+VK+GN=iDhDV2ZDJbBsxrjZ3Qoyotk_L0DvsbwDVvqrpFZ8fQ@mail.gmail.com>
 <29982969-92f6-b6d0-aeae-22edb401e3ac@redhat.com>
 <CA+VK+GOccmwVov9Fx1eMZkzivBduWRuoyAuCRtjMfM4LemRkgw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fe21094c-bdb0-b802-482e-72bc17e5232a@redhat.com>
Date:   Mon, 11 May 2020 19:34:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CA+VK+GOccmwVov9Fx1eMZkzivBduWRuoyAuCRtjMfM4LemRkgw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Jonathan, I think the remaining sticky point is this one:

On 11/05/20 19:02, Jonathan Adams wrote:
> I think I'd characterize this slightly differently; we have a set of
> statistics which are essentially "in parallel":
> 
>   - a variety of statistics, N CPUs they're available for, or
>   - a variety of statistics, N interfaces they're available for.
>   - a variety of statistics, N kvm object they're available for.
> 
> Recreating a parallel hierarchy of statistics any time we add/subtract
> a CPU or interface seems like a lot of overhead.  Perhaps a better 
> model would be some sort of "parameter enumn" (naming is hard;
> parameter set?), so when a CPU/network interface/etc is added you'd
> add its ID to the "CPUs" we know about, and at removal time you'd
> take it out; it would have an associated cbarg for the value getting
> callback.
> 
>> Yep, the above "not create a dentry" flag would handle the case where
>> you sum things up in the kernel because the more fine grained counters
>> would be overwhelming.
>
> nodnod; or the callback could handle the sum itself.

In general for statsfs we took a more explicit approach where each
addend in a sum is a separate stats_fs_source.  In this version of the
patches it's also a directory, but we'll take your feedback and add both
the ability to hide directories (first) and to list values (second).

So, in the cases of interfaces and KVM objects I would prefer to keep
each addend separate.

For CPUs that however would be pretty bad.  Many subsystems might
accumulate stats percpu for performance reason, which would then be
exposed as the sum (usually).  So yeah, native handling of percpu values
makes sense.  I think it should fit naturally into the same custom
aggregation framework as hash table keys, we'll see if there's any devil
in the details.

Core kernel stats such as /proc/interrupts or /proc/stat are the
exception here, since individual per-CPU values can be vital for
debugging.  For those, creating a source per stat, possibly on-the-fly
at hotplug/hot-unplug time because NR_CPUS can be huge, would still be
my preferred way to do it.

Thanks,

Paolo

