Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73BCE2741F2
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Sep 2020 14:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgIVMSo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Sep 2020 08:18:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29737 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726588AbgIVMSo (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Sep 2020 08:18:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600777123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eNZeY9r9xWdVVmR/OV9x+niYNFf+cGcA16jaTwwfZ90=;
        b=EAbtUIJFJqUOgMAbG8oD40KmiF7gDN3FoUYcwakD+cOjV4hxCi4OiHyQILWEoDEVB5IGgd
        cYvPn+oQururJlghfCmsBG1ckenymNSNZ4xfuclaWdk8feRGvd00yAtDDL/y25dOz9R68u
        tIckhMCmfmnAD2jnteDO41eJJOwysQ8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-gnsxwgQzMY-PEAQxwcGngA-1; Tue, 22 Sep 2020 08:18:41 -0400
X-MC-Unique: gnsxwgQzMY-PEAQxwcGngA-1
Received: by mail-wr1-f71.google.com with SMTP id 33so7372640wre.0
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Sep 2020 05:18:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eNZeY9r9xWdVVmR/OV9x+niYNFf+cGcA16jaTwwfZ90=;
        b=dHibgJTmQCK6I9fN4Hoks7J/dZiZXug7dWToINBO+lvdXgYMmF/u2MengRPIkL+Ltk
         mqn1setqlcSIbQiclnFrN0ljmiL3IW5qjEaQ0uFKc3Uke4tDlc6tkc/5L4Up4uZEOw3H
         ocBhX68bmmLNPLvNeVpWlPV0C7Nf0OfJfij92JRrUxFhtC++4UmK8IQDiXs4cmah9mZS
         nrt8IqMtTt1W5uUJpFuHqKIXxcdaDJumgoVB423MOhgPVzubdHpLi+mrvBriJVWnPi3D
         R2J1iQvi8qGCTh7elb7wIU+v9czaLGi0TS5evDfqr20TKrJHj9R+HWakGawirNAJOvuv
         3UTA==
X-Gm-Message-State: AOAM532lHAoLniF+hfWpA3nBEL0gkUbpn46InZQmqrfccARL68dtSdXD
        CBqOOE0HvBCikg6W5rOA4+XFR2iywwjD5Co9jQoqjecbhIXTTTbH+H6LA/teItqUjzL2HVR55/z
        EQSrTSdsf3pUAy39apg==
X-Received: by 2002:a05:600c:2189:: with SMTP id e9mr754162wme.8.1600777120291;
        Tue, 22 Sep 2020 05:18:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyltv95D02XwMDIvvSOgO71sFd0oy5jdM3qkUXkXfyr1VqYo6t24oZfKylnZb/F1LLhv96mPA==
X-Received: by 2002:a05:600c:2189:: with SMTP id e9mr754148wme.8.1600777120115;
        Tue, 22 Sep 2020 05:18:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec2c:90a9:1236:ebc6? ([2001:b07:6468:f312:ec2c:90a9:1236:ebc6])
        by smtp.gmail.com with ESMTPSA id u63sm4618338wmb.13.2020.09.22.05.18.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 05:18:39 -0700 (PDT)
Subject: Re: [GIT PULL] Please pull my kvm-ppc-next-5.10-1 tag
To:     Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org
References: <20200922041930.GA531519@thinks.paulus.ozlabs.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b2540d3b-844f-f204-7783-079ad9103ada@redhat.com>
Date:   Tue, 22 Sep 2020 14:18:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200922041930.GA531519@thinks.paulus.ozlabs.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 22/09/20 06:19, Paul Mackerras wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-next-5.10-1

Pulled, thanks.

Paolo

