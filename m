Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B801E46B2
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 May 2020 17:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389452AbgE0PAz (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 27 May 2020 11:00:55 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32284 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389419AbgE0PAu (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 27 May 2020 11:00:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590591649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S79dLGaDC34U88k/muBN2/cWWvIJSeZD2zX/jWO3DQQ=;
        b=g2rrPUM75riI+DtvHnoF2WAwoBSONDpP+AtLrZcuUs1JNfZcqfBFhxH72/4KJowcc3Fq9d
        HiWYmmiLxY94abgy4EmKJnTOqWMO3kX8KAQSHdZNsilBFmB848B/7rOZU2d+FIh9CD2UlQ
        QU0UQbHwvwsJXnc0RWrjisGI+J75pk0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-aU3ZUXyxMMqDXkxGbohdLw-1; Wed, 27 May 2020 11:00:47 -0400
X-MC-Unique: aU3ZUXyxMMqDXkxGbohdLw-1
Received: by mail-ed1-f70.google.com with SMTP id f10so10177724edn.10
        for <kvm-ppc@vger.kernel.org>; Wed, 27 May 2020 08:00:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S79dLGaDC34U88k/muBN2/cWWvIJSeZD2zX/jWO3DQQ=;
        b=BH2SfkeCUNux2uF9KTsT7kYkJuUxZU7eblkIhJ4EJSZDBe7GQk3w1Tg641sAoLYjLV
         3ItNfr5SrLn2muhUdj0a7el9M9x0/8Um3nlpy2fjD5rvtEtgB7ZDReQYT30mwudAJGOq
         EPuuPz+gO2U+4aAeTScmcvtwtX1HrmfznXmeTYLKtwHhi208f+AFgjt0Agv/0y3lU9bg
         vpJjZm99ex7GIoZciWGuOHQ1Acb/F7HxCwGpif3bCsdkLBw21PRffxJsVmAfXzc9RZrP
         9VlkSdu1uWEEo5z/ZcP8L2tR0uxD9KlEMpowU+1QsG7wRU/DJYjgzTWm5cnPVdVFSvO1
         Riwg==
X-Gm-Message-State: AOAM532pCe7eAiXlf9mmdiHiicMt1VQfBt0z/nXYctx7D2rIqhuJRAp4
        nc8RlQ6sBKbvaetpOfr2wel5DcH0ZPkFxrIs9/RF3pdbijIOdfM/edwYUJZOOtL246+2oTaRzak
        mvNH9/pokwWOPTQpKuw==
X-Received: by 2002:a17:906:1442:: with SMTP id q2mr3491297ejc.33.1590591646044;
        Wed, 27 May 2020 08:00:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxzNY5UhO1mssuYEm2F2UYGESNfuhTc2d/FaV+VoTyW39e+803AKyGa34dCi6Lxc3HyJGruA==
X-Received: by 2002:a17:906:1442:: with SMTP id q2mr3491234ejc.33.1590591645542;
        Wed, 27 May 2020 08:00:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id l1sm3053400ejd.114.2020.05.27.08.00.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 08:00:45 -0700 (PDT)
Subject: Re: [PATCH v3 0/7] Statsfs: a new ram-based file system for Linux
 kernel statistics
To:     Andrew Lunn <andrew@lunn.ch>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jim Mattson <jmattson@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Emanuele Giuseppe Esposito <e.emanuelegiuseppe@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Jonathan Adams <jwadams@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
References: <20200526110318.69006-1-eesposit@redhat.com>
 <20200526153128.448bfb43@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <6a754b40-b148-867d-071d-8f31c5c0d172@redhat.com>
 <20200527133309.GC793752@lunn.ch>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b0d11337-3ea4-d874-6013-ff8c3e9d6f26@redhat.com>
Date:   Wed, 27 May 2020 17:00:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200527133309.GC793752@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 27/05/20 15:33, Andrew Lunn wrote:
>> I don't really know a lot about the networking subsystem, and as it was
>> pointed out in another email on patch 7 by Andrew, networking needs to
>> atomically gather and display statistics in order to make them consistent,
>> and currently this is not supported by stats_fs but could be added in
>> future.
> 
> Do you have any idea how you will support atomic access? It does not
> seem easy to implement in a filesystem based model.

Hi Andrew,

there are plans to support binary access.  Emanuele and I don't really
have a plan for how to implement it, but there are developers from
Google that have ideas (because Google has a similar "metricfs" thing
in-house).

I think atomic access would use some kind of "source_ops" struct
containing create_snapshot and release_snapshot function pointers.

Paolo

