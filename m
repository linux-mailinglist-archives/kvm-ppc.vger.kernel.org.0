Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5786E1C5EB2
	for <lists+kvm-ppc@lfdr.de>; Tue,  5 May 2020 19:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbgEERWG (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 5 May 2020 13:22:06 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38326 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730128AbgEERWB (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 5 May 2020 13:22:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588699319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NLBNUm/fluAXkFzdIYicKdp0CV+hI9Whe6Z74OvWRXA=;
        b=WOCKK9qmAGW/W4kNPJifS6UNnAdyf/8ruDXkpiSDUXTI6gSlgE78zW6SAngdQvE7eguELz
        cHdIl7Hzxd6k6XO/TvXP7znXxa034cV660rLiqOJvNvCU+RIvA5i1SZo9gkjx+CcY9WZlt
        nxxkkylpPT9htV70byFQ+RbUBMg6FWo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-ajObJuAsOgawV9Kt0L21Yw-1; Tue, 05 May 2020 13:21:57 -0400
X-MC-Unique: ajObJuAsOgawV9Kt0L21Yw-1
Received: by mail-wm1-f72.google.com with SMTP id q5so1364398wmc.9
        for <kvm-ppc@vger.kernel.org>; Tue, 05 May 2020 10:21:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NLBNUm/fluAXkFzdIYicKdp0CV+hI9Whe6Z74OvWRXA=;
        b=euqpTaT+kTFA3h5ybEp7PElj535JHu/3urSd9tQOCjxlMyj0QmV/v5z2nIt86sDJ80
         bdRmg2uEZy5ijEF1UhZkOio2ezikGiShaEONXeF12RD2BfMu3nBw2QehJQpN1S7YXPHX
         ZjMFKWXSzAYU0sPp7kXjoIPM6sR7aCajI1QSvy61Q+niIlK61P9fox1N8/rRxHaxNhNi
         NHnWI/mmmCqVGDm8NHi82G14WAR75Uz1xE+i2RF3xq0wKY+JSp9YA5TRx4nDPJ1Y9eTx
         A4EIs2dZTP1VC3a6b6UkPHlutbd4YaSqTr/N3bsf57Tdx0yyz9tXDCVoGLbLRmexuXZ4
         Z0LQ==
X-Gm-Message-State: AGi0PuZutyEgq7dETKFaWyrgiFhjgv96k9s6xC8z+FlMj0YReyTFXYRZ
        dv/DsoqJ9gwogH+7ndBH8PmgdFC/luoEboDjgprhAM44NOnjyOZTweeZ7NFvuulKQH3ls9HhZy2
        bSaVngZ1woNiz320OTw==
X-Received: by 2002:adf:dfcf:: with SMTP id q15mr4600165wrn.137.1588699316440;
        Tue, 05 May 2020 10:21:56 -0700 (PDT)
X-Google-Smtp-Source: APiQypIVV+df8r3YAEgu8Bx29AN2Dhx6gB2SP3zMh8KI8zL75cn1CSbSYF73IUInRaU7M6AlZnT4Aw==
X-Received: by 2002:adf:dfcf:: with SMTP id q15mr4600142wrn.137.1588699316221;
        Tue, 05 May 2020 10:21:56 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id q17sm4693287wmj.45.2020.05.05.10.21.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 10:21:55 -0700 (PDT)
Subject: Re: [PATCH v2 0/5] Statsfs: a new ram-based file sytem for Linux
 kernel statistics
To:     David Rientjes <rientjes@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Jonathan Adams <jwadams@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Emanuele Giuseppe Esposito <e.emanuelegiuseppe@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
References: <20200504110344.17560-1-eesposit@redhat.com>
 <alpine.DEB.2.22.394.2005041429210.224786@chino.kir.corp.google.com>
 <f2654143-b8e5-5a1f-8bd0-0cb0df2cd638@redhat.com>
 <CALMp9eQYcLr_REzDC1kWTHX4SJWt7x+Zd1KwNvS1YGd5TVM1xA@mail.gmail.com>
 <1d12f846-bf89-7b0a-5c71-e61d83b1a36f@redhat.com>
 <alpine.DEB.2.22.394.2005051003380.216575@chino.kir.corp.google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6cfdf81f-caef-2489-0906-25915d9d58ff@redhat.com>
Date:   Tue, 5 May 2020 19:21:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.22.394.2005051003380.216575@chino.kir.corp.google.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 05/05/20 19:07, David Rientjes wrote:
>> I am totally in favor of having a binary format, but it should be
>> introduced as a separate series on top of this one---and preferably by
>> someone who has already put some thought into the problem (which
>> Emanuele and I have not, beyond ensuring that the statsfs concept and
>> API is flexible enough).
>>
> The concern is that once this series is merged then /sys/kernel/stats 
> could be considered an ABI and there would be a reasonable expectation 
> that it will remain stable, in so far as the stats that userspace is 
> interested in are stable and not obsoleted.
> 
> So is this a suggestion that the binary format becomes complementary to 
> statsfs and provide a means for getting all stats from a single subsystem, 
> or that this series gets converted to such a format before it is merged?

The binary format should be complementary.  The ASCII format should
indeed be considered stable even though individual statistics would come
and go.  It may make sense to allow disabling ASCII files via mount
and/or Kconfig options; but either way, the binary format can and should
be added on top.

I have not put any thought into what the binary format would look like
and what its features would be.  For example these are but the first
questions that come to mind:

* would it be possible to read/clear an arbitrary statistic with
pread/pwrite, or do you have to read all of them?

* if userspace wants to read the schema just once and then read the
statistics many times, how is it informed of schema changes?

* and of course the details of how the schema (names of stat and
subsources) is encoded and what details it should include about the
values (e.g. type or just signedness).

Another possibility is to query stats via BPF.  This could be a third
way to access the stats, or it could be alternative to a binary format.

Paolo

