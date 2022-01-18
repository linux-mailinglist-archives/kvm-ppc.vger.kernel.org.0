Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7269E492B12
	for <lists+kvm-ppc@lfdr.de>; Tue, 18 Jan 2022 17:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiARQUp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 18 Jan 2022 11:20:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54174 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235038AbiARQUo (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 18 Jan 2022 11:20:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642522844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EwrulS3gzA/74heRhQ+jQxvPAPi0xIckrPJaoqht2/c=;
        b=aXsitatiuS2AX7jhB7Scld+wJMFvVFgE9KUQLIn1eUv/V/aPH5WyxrKiT5I0/nVyyM1VmQ
        /UEgZhLluZMmzuH1MT/8IgXc30XmChWNvK6gUkGNfodK8wLT252++OxG3NWxMTrcF/ub8S
        W/JzbGAWxpubBQi+h9lfLNEc6RByPDQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-WgZLpHXwM_G4hS4-qRAxMQ-1; Tue, 18 Jan 2022 11:20:41 -0500
X-MC-Unique: WgZLpHXwM_G4hS4-qRAxMQ-1
Received: by mail-wm1-f72.google.com with SMTP id o3-20020a05600c4fc300b0034aee9534bdso6318528wmq.2
        for <kvm-ppc@vger.kernel.org>; Tue, 18 Jan 2022 08:20:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EwrulS3gzA/74heRhQ+jQxvPAPi0xIckrPJaoqht2/c=;
        b=UqJtohPKzJrtTM9g7rG+mZWQ2dnF1jsTfWgCK0E457n6DMVzRrsvCgiPNVQrCsMwKl
         knv2DJC2JMNti1YO+DBZXuw6ehrrV/IrkP2l86VuLyE2x/8ytvz0uN8P8US074e2IECl
         LAZ/sDlsKn2iIOSHRXH/N0GJOse1lXyXJ6GfOwre8QScfQNkZ2IGk+SgWz2MelPl+zsQ
         wa7oqzSRs6ZYx+GrqtBRLFv4kK2FtzP9usglkJ9+p4Zgbeyqsq2phuiTaT89xrGcvT1L
         9Fc8EX8XVDw3aTS0qagjK2aFHoMZO1jQ2xzCMFfLYvwxIjRQgCizleubiaDQFKquAsiK
         1X3A==
X-Gm-Message-State: AOAM530A96E6Glg7h/Lb2YOAszDw+2/YBvXBC1AndSjDULaenyGdI97+
        e6AyVZDtOo5aNZzvQt1fZCESkS7oEJmvemtVaLsBiqxqEFVRDxSilAaLc5jP0oEcxc72qRnPK0/
        0Xf2Y0b1W9xJHujvBJw==
X-Received: by 2002:a5d:4c4d:: with SMTP id n13mr25057004wrt.641.1642522840125;
        Tue, 18 Jan 2022 08:20:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwTz1c1QQcAMTiHafm/jmwdXgrf7wUWM5hGJvGgdN/CAmFDEzHQguURZEtsbIR0m3l3jikB/Q==
X-Received: by 2002:a5d:4c4d:: with SMTP id n13mr25056991wrt.641.1642522839929;
        Tue, 18 Jan 2022 08:20:39 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id h2sm3124218wmq.2.2022.01.18.08.20.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 08:20:39 -0800 (PST)
Message-ID: <0c3b360a-8b95-0a18-a5df-59249247c291@redhat.com>
Date:   Tue, 18 Jan 2022 17:20:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [kvm-unit-tests] Permitted license for new library
Content-Language: en-US
To:     Alexandru Elisei <alexandru.elisei@arm.com>, thuth@redhat.com,
        lvivier@redhat.com, imbrenda@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        kvm-ppc@vger.kernel.org, linux-s390@vger.kernel.org
References: <YeboYFQQtuQH1+Rf@monolith.localdoman>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YeboYFQQtuQH1+Rf@monolith.localdoman>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 1/18/22 17:18, Alexandru Elisei wrote:
> Hello,
> 
> I would like to know what licenses are permitted when adding a new library
> to kvm-unit-tests (similar to libfdt). Is it enough if the library is
> licensed under one of the GPLv2 compatible licenses [1] or are certain
> licenses from that list not accepted for kvm-unit-tests?
> 
> [1] https://www.gnu.org/licenses/license-list.html#GPLCompatibleLicenses

Any GPLv2-compatible license is acceptable.  GPLv2+ compatibility is 
nice but not required.

Paolo

